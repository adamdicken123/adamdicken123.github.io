---
layout: post
title: Jupyter meets Jekyll
---
My intention of creating this blog is to showcase some bits and pieces I play around with in a friendly way. I have been coding in python for a little while and recently started to use Jupyter notebooks as a neat way to explain findings.

When I then came across Jekyll and GitHub pages, I thought this is going to be great. An out the box solution to serve my Jupyter notebooks (and other miscellaneous ramblings) in a coherent, bloggy type way. Well, not quite... !

## The Problem
My assumption was that because Jekyll supports Markdown, and Jupyter notebooks can easily be converted to markdown this would all be a doddle. However, it turns out that the Jekyll flavoured Markdown is not quite compatible with the markdown you can get from Jupyter. And also there is an element of path problems for resources. Oh no!

The detail is GitHub pages / Jekyll supports [kramdown](https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0). Whilst nbconvert used by Jupyter outputs .md files.

After searching about a bit I found far fewer solutions to this issue than I thought there would be. And solutions that worked for the now deprecated iPython format didnt quite work although it did give me some good ideas.

## The Solution
The first guide I actually found that worked easily was this one from [Brian Caffey](http://briancaffey.github.io/2016/03/14/ipynb-with-jekyll.html), good simple approach but a little bit manual.

```python
%matplotlib inline
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

# the histogram of the data
n, bins, patches = plt.hist(blight_violations_grouped, 50, facecolor='green', alpha=0.75)

plt.xlabel('Number of Violations at Single Location')
plt.ylabel('Frequency')
plt.yscale('log')
plt.title(r'Examining the frequency of violations at a single location')
plt.axis([0, 100, 0, 50000])
plt.grid(True)

plt.show()
```

{% highlight python %}
%matplotlib inline
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

# the histogram of the data
n, bins, patches = plt.hist(blight_violations_grouped, 50, facecolor='green', alpha=0.75)

plt.xlabel('Number of Violations at Single Location')
plt.ylabel('Frequency')
plt.yscale('log')
plt.title(r'Examining the frequency of violations at a single location')
plt.axis([0, 100, 0, 50000])
plt.grid(True)

plt.show()
{% endhighlight %}

![png]({{ site.github.url }}/Feature_Engineering_files/Feature_Engineering_7_0.png)
