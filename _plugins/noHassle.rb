module Jekyll
  class Nohassle < Generator
    safe false
    ###############################
    # options
      # folder with notebooks
      @@folder = '_notebooks'

      # folder to put posts
      @@posts_folder = '_posts'

      # The prepended name on generated resources folder
      @@nbconvert_append = '_files'

      # Add yaml front matter ?
      @@add_frontmatter = false

      # resources regex
      @@resources_regex = '!\[(.*)\]\((.*)\)'

      # resources folder
      @@resources_folder = 'notebooks_resources'

      # base url
      @@baseurl = '{{ site.baseurl }}'

    # end of options
    ################################


    def generate(site)
      require 'FileUtils'
      # Logging
      require 'logger'
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO

      # Get all notebook files in specified directory
      @notebook_files = Dir["#{@@folder}/*/*.ipynb"]

      @notebook_files.each_with_index { |notebook_file,i|
        convert = true

        # directory
        dir = File.dirname(notebook_file)
        # Get basename
        name = File.basename(notebook_file,File.extname(notebook_file))
        logger.info "Found notebook: #{name} in #{dir}"

        # therefore markdown should be
        logger.info "Looking to see if post already exists #{@@posts_folder}/#{name}.md"
        md_file = Dir["#{@@posts_folder}\/" + '[0-9]*-[0-9]*-[0-9]*' + "-#{name}.md"]

        # check if up to date
        if md_file.any?
          logger.info "Found markdown #{md_file}, comparing timestamps"
          # Get modified Date
          last_updated = File.mtime(notebook_file)
          # Get last generated Date
          last_generated = File.mtime(md_file[0])

          if last_generated >= last_updated
            logger.info "Markdown up to date, no conversion needed.."
            convert = false
          else
            logger.info "Markdown out of date, will generate.."
          end
        else
          logger.info "No markdown exists yet for notebook, will generate.."
        end

        # convert notebooks to markdown
        if convert
          # convert file
          logger.info "generating markdown.."
          system "jupyter nbconvert \"#{notebook_file}\" --to markdown"

          # resulting markdown file
          md_file = Dir["#{dir}/#{name}.md"][0]
          logger.info "picked up output markdown file #{md_file}"

          md_content = File.read(md_file)

          # Copy resources if required
          nbconvert_resources = "#{dir}/#{name}#{@@nbconvert_append}"
          nbconvert_resources_files = Dir["#{nbconvert_resources}/*"]
          if !nbconvert_resources_files.nil? and !nbconvert_resources_files.empty?
            jekyll_resources_folder = "#{@@resources_folder}/#{name}#{@@nbconvert_append}"

            logger.info "Copying generated resources from \"#{nbconvert_resources}\" to \"#{jekyll_resources_folder}\""
            # Make parent directories
            logger.info "Making parent directories"
            FileUtils.mkdir_p "#{jekyll_resources_folder}", :verbose => true
            logger.info "Copying files"
            FileUtils.copy_entry "#{nbconvert_resources}", "#{jekyll_resources_folder}", :verbose => true

            # look for resource paths in file and update paths
            logger.info "Appending paths in markdown file #{md_file} with #{@@baseurl}/#{jekyll_resources_folder}"
            md_content = md_content.gsub(/!\[(?<type>.*)\]\((?<path>.*)\)/, '![\k<type>](' + "#{@@baseurl}/#{@@resources_folder}" + '/\k<path>)')
          else
            logger.info "No generated resources found for notebook"
          end

          logger.info "Writing markdown to posts_folder"
          File.open("temp.md", 'w') do |file|

            # Add front matter with title and format
            if @@add_frontmatter
              logger.info "Adding front matter to post. Title = #{name}"
              file.write("---\nlayout: post\ntitle: #{name}\n---\n")
            end
            file.write(md_content)

          end

          # File.delete(f)

          File.rename('temp.md', File.basename(md_file))

          # Renaming files with appropriate date
          now = Date.today.strftime("%Y-%m-%d")
          FileUtils.mkdir_p "#{@@posts_folder}", :verbose => true
          File.rename(File.basename(md_file), "#{@@posts_folder}/#{now}-#{File.basename(md_file.gsub(/\s+/, '-'))}")

        end
      }


      # @files.each_with_index { |f,i|
      #   old_text = File.read(f)
      #   n = f.dup
      #   n[0..@@folder.length] = ""
      #   n = n.slice(0..-4)
      #   File.open("temp.md", 'w') do |file|
      #
      #     # Add front matter with title and format
      #     file.write("---\nlayout: post\ntitle: #{n}\n---\n")
      #     file.write(old_text)
      #
      #   end
      #
      #   File.delete(f)
      #
      #   File.rename('temp.md', f)
      #
      #   # Renaming files with appropriate date
      #   now = Date.today.strftime("%Y-%m-%d")
      #   File.rename(f, "_posts/#{now}-#{File.basename(f.gsub(/\s+/, '-'))}")
      # }

    end
  end
end
