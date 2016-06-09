---
layout: post
title: Jupyter meets Jekyll
---
My intention of creating this blog is to showcase some bits and pieces I play around with in a friendly way. I have been coding in python for a little while and recently started to use Jupyter notebooks as a neat way to explain findings.

When I then came across Jekyll and GitHub pages, I thought this is going to be great. An out the box solution to serve my Jupyter notebooks (and other miscellaneous ramblings) in a coherent, bloggy type way. Well, not quite... !

## The Problem
My assumption was that because Jekyll supports Markdown, and Jupyter notebooks can easily be converted to markdown this would all be a doddle. However, it turns out that the Jekyll flavoured Markdown is not quite compatible with the markdown you can get from Jupyter. Oh, and also there is an element of path problems for resources. Oh no!

> GitHub pages / Jekyll supports [kramdown](https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0). Whilst nbconvert used by Jupyter outputs .md files.

After searching about a bit I found far fewer solutions to this issue than I thought there would be. And solutions that worked for the now deprecated iPython format didnt quite work for Jupyter notebooks although it did give me some good ideas.

## The Solution
The first guide I actually found that worked easily was this one from [Brian Caffey](http://briancaffey.github.io/2016/03/14/ipynb-with-jekyll.html), this is a good simple approach but a little bit manual in updating the path.

This is what I have currently found works quite well:

### 0. Setup directory structure
In

### 1. Create your .ipynb notebook
In the very first cell in your notebook add a `Raw NBConvert` cell. This will be what Jekyll uses to interpret the post, e.g.
```
---
layout: post
title: Jupyter meets Jekyll
---
```

### 2. Do your thing
Now do your thing in your Jupyter notebook and include any and all markdown you wish to include in your blog post - e.g. see the [notebook source for this post]().

> Currently I use the Jupyter servlet in my browser for editing notebooks - I use PyCharm as my IDE of choice but I find it doesn't play that nice with notebooks. Comment below if you have any good suggestions / thoughts on notebooks and IDE's.

For the sake of this tutorial here is a nice simple bit of python to generate a chart:


```python
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline

x = np.linspace(0, 4*np.pi, 100)
y = np.sin(x)

plt.plot(x, y)
```




    [<matplotlib.lines.Line2D at 0x88b22f0>]




![png]({{ site.url }}/Jupyter_meets_Jekyll_files/Jupyter_meets_Jekyll_2_1.png)


### 3.

### 4. Bokeh
Now basic plots are working fine, but lets say you want to include some Bokeh plots. Bokeh is powered by javascript and so we need to make sure we get the right scripts on the page or it ain't gonna work.



```python
from bokeh.plotting import *
from bokeh.models import ColumnDataSource
from bokeh.resources import CDN
# Set the output to be inline
output_notebook(resources=CDN)
```



    <div class="bk-banner">
        <a href="http://bokeh.pydata.org" target="_blank" class="bk-logo bk-logo-small bk-logo-notebook"></a>
        <span id="9b426a59-b35f-4dd4-a0e8-3443e9de8c54">Loading BokehJS ...</span>
    </div>





```python
source = ColumnDataSource(dict(x=x,y=y))

p1 = figure(title="Legend Example")
p1.circle(x, y, source=source, legend="Asin(x)")
```




    <bokeh.models.renderers.GlyphRenderer at 0x8e1a30>




```python
def update(A=1):
    source.data['y'] = A * np.sin(source.data['x'])
    source.push_notebook()
```


```python
show(p1)  # open a browser
```




    <div class="plotdiv" id="a462bc4d-b713-4c3f-83e0-e82905a4ef1b"></div>
<script type="text/javascript">

  (function(global) {
    function now() {
      return new Date();
    }

    if (typeof (window._bokeh_onload_callbacks) === "undefined") {
      window._bokeh_onload_callbacks = [];
    }

    function run_callbacks() {
      window._bokeh_onload_callbacks.forEach(function(callback) { callback() });
      delete window._bokeh_onload_callbacks
      console.info("Bokeh: all callbacks have finished");
    }

    function load_libs(js_urls, callback) {
      window._bokeh_onload_callbacks.push(callback);
      if (window._bokeh_is_loading > 0) {
        console.log("Bokeh: BokehJS is being loaded, scheduling callback at", now());
        return null;
      }
      if (js_urls == null || js_urls.length === 0) {
        run_callbacks();
        return null;
      }
      console.log("Bokeh: BokehJS not loaded, scheduling load and callback at", now());
      window._bokeh_is_loading = js_urls.length;
      for (var i = 0; i < js_urls.length; i++) {
        var url = js_urls[i];
        var s = document.createElement('script');
        s.src = url;
        s.async = false;
        s.onreadystatechange = s.onload = function() {
          window._bokeh_is_loading--;
          if (window._bokeh_is_loading === 0) {
            console.log("Bokeh: all BokehJS libraries loaded");
            run_callbacks()
          }
        };
        s.onerror = function() {
          console.warn("failed to load library " + url);
        };
        console.log("Bokeh: injecting script tag for BokehJS library: ", url);
        document.getElementsByTagName("head")[0].appendChild(s);
      }
    };var element = document.getElementById("a462bc4d-b713-4c3f-83e0-e82905a4ef1b");
    if (element == null) {
      console.log("Bokeh: ERROR: autoload.js configured with elementid 'a462bc4d-b713-4c3f-83e0-e82905a4ef1b' but no matching script tag was found. ")
      return false;
    }

    var js_urls = [];

    var inline_js = [
      function(Bokeh) {
        Bokeh.$(function() {
            var docs_json = {"95bcb163-355b-4659-8385-8f7c35eaf67c":{"roots":{"references":[{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"},"ticker":{"id":"5118cf7a-bb85-45fe-af9f-a7370014987a","type":"BasicTicker"}},"id":"dbdb57f8-684f-4622-833b-264dac8a67d8","type":"Grid"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"83fea780-4d88-46c9-bacd-098fd950404f","type":"HelpTool"},{"attributes":{"fill_alpha":{"value":0.1},"fill_color":{"value":"#1f77b4"},"line_alpha":{"value":0.1},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"c55dab20-831d-41c3-8a8c-0163c5be0b35","type":"Circle"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"7fb152e8-19fc-4d65-ba24-eb6e7117e8b1","type":"PreviewSaveTool"},{"attributes":{"callback":null,"column_names":["y","x","y","x"],"data":{"x":[0.0,0.12693303650867852,0.25386607301735703,0.3807991095260356,0.5077321460347141,0.6346651825433925,0.7615982190520711,0.8885312555607496,1.0154642920694281,1.1423973285781066,1.269330365086785,1.3962634015954636,1.5231964381041423,1.6501294746128208,1.7770625111214993,1.9039955476301778,2.0309285841388562,2.1578616206475347,2.284794657156213,2.4117276936648917,2.53866073017357,2.6655937666822487,2.792526803190927,2.9194598396996057,3.0463928762082846,3.173325912716963,3.3002589492256416,3.42719198573432,3.5541250222429985,3.681058058751677,3.8079910952603555,3.934924131769034,4.0618571682777125,4.188790204786391,4.3157232412950695,4.442656277803748,4.569589314312426,4.696522350821105,4.823455387329783,4.950388423838462,5.07732146034714,5.204254496855819,5.331187533364497,5.458120569873176,5.585053606381854,5.711986642890533,5.838919679399211,5.96585271590789,6.092785752416569,6.219718788925247,6.346651825433926,6.473584861942604,6.600517898451283,6.727450934959961,6.85438397146864,6.981317007977318,7.108250044485997,7.235183080994675,7.362116117503354,7.489049154012032,7.615982190520711,7.742915227029389,7.869848263538068,7.996781300046746,8.123714336555425,8.250647373064103,8.377580409572783,8.50451344608146,8.631446482590139,8.758379519098817,8.885312555607497,9.012245592116175,9.139178628624853,9.266111665133531,9.39304470164221,9.519977738150889,9.646910774659567,9.773843811168245,9.900776847676925,10.027709884185603,10.15464292069428,10.28157595720296,10.408508993711639,10.535442030220317,10.662375066728995,10.789308103237675,10.916241139746353,11.04317417625503,11.170107212763709,11.297040249272388,11.423973285781067,11.550906322289745,11.677839358798423,11.804772395307102,11.93170543181578,12.058638468324459,12.185571504833138,12.312504541341816,12.439437577850494,12.566370614359172],"y":[0.0,0.12659245357374926,0.2511479871810792,0.3716624556603276,0.4861967361004687,0.5929079290546404,0.690079011482112,0.7761464642917568,0.8497254299495144,0.9096319953545183,0.9549022414440739,0.984807753012208,0.998867339183008,0.9968547759519424,0.9788024462147787,0.9450008187146685,0.8959937742913359,0.8325698546347714,0.7557495743542583,0.6667690005162917,0.5670598638627709,0.4582265217274105,0.3420201433256689,0.2203105327865408,0.09505604330418244,-0.03172793349806786,-0.15800139597335008,-0.28173255684142984,-0.4009305354066138,-0.5136773915734064,-0.6181589862206053,-0.7126941713788629,-0.7957618405308321,-0.8660254037844388,-0.9223542941045814,-0.9638421585599422,-0.9898214418809327,-0.9998741276738751,-0.9938384644612541,-0.9718115683235417,-0.9341478602651068,-0.881453363447582,-0.8145759520503358,-0.7345917086575332,-0.6427876096865396,-0.5406408174555974,-0.4297949120891719,-0.31203344569848707,-0.18925124436040974,-0.06342391965656452,0.06342391965656492,0.18925124436041013,0.31203344569848745,0.4297949120891715,0.5406408174555978,0.6427876096865391,0.7345917086575334,0.8145759520503356,0.8814533634475821,0.9341478602651067,0.9718115683235418,0.9938384644612541,0.9998741276738751,0.9898214418809328,0.963842158559942,0.9223542941045816,0.8660254037844383,0.7957618405308319,0.7126941713788629,0.6181589862206056,0.5136773915734058,0.40093053540661344,0.2817325568414299,0.15800139597335056,0.03172793349806701,-0.09505604330418282,-0.22031053278654034,-0.342020143325668,-0.45822652172741085,-0.5670598638627707,-0.6667690005162913,-0.7557495743542588,-0.8325698546347716,-0.8959937742913359,-0.9450008187146683,-0.9788024462147789,-0.9968547759519424,-0.998867339183008,-0.9848077530122081,-0.9549022414440737,-0.9096319953545183,-0.8497254299495145,-0.7761464642917573,-0.6900790114821116,-0.5929079290546404,-0.48619673610046904,-0.3716624556603267,-0.2511479871810788,-0.1265924535737493,-4.898587196589413e-16]}},"id":"e65fa6d8-3a27-4b44-9ed2-947d42172992","type":"ColumnDataSource"},{"attributes":{"formatter":{"id":"6fb3bb8b-5a9b-4867-be13-5030b5d888e7","type":"BasicTickFormatter"},"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"},"ticker":{"id":"5118cf7a-bb85-45fe-af9f-a7370014987a","type":"BasicTicker"}},"id":"38c71a03-03bf-4ce9-9823-2a8409a0e148","type":"LinearAxis"},{"attributes":{},"id":"2e201565-8b3d-4d90-a385-59e2dc88d255","type":"BasicTicker"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"d2ddc28b-bfda-4de3-ae05-2b4c16bea0a3","type":"ResizeTool"},{"attributes":{},"id":"8829f7cc-df0c-48b0-92bf-fce2ce4a5705","type":"ToolEvents"},{"attributes":{"formatter":{"id":"49aba325-e9fa-4ec1-b543-1f254dd2524e","type":"BasicTickFormatter"},"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"},"ticker":{"id":"2e201565-8b3d-4d90-a385-59e2dc88d255","type":"BasicTicker"}},"id":"cf7134df-96b3-49a8-8ced-ad0ae0d6b950","type":"LinearAxis"},{"attributes":{"bottom_units":"screen","fill_alpha":{"value":0.5},"fill_color":{"value":"lightgrey"},"left_units":"screen","level":"overlay","line_alpha":{"value":1.0},"line_color":{"value":"black"},"line_dash":[4,4],"line_width":{"value":2},"plot":null,"render_mode":"css","right_units":"screen","top_units":"screen"},"id":"219525fc-e8f6-4fe8-951a-a171e0484dde","type":"BoxAnnotation"},{"attributes":{"callback":null},"id":"98625ef6-234a-4043-8838-560fa322f33d","type":"DataRange1d"},{"attributes":{"fill_color":{"value":"#1f77b4"},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"ccd9c5d0-9d20-4689-8b45-11caadba9b6f","type":"Circle"},{"attributes":{"dimension":1,"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"},"ticker":{"id":"2e201565-8b3d-4d90-a385-59e2dc88d255","type":"BasicTicker"}},"id":"cf3964cd-1f7a-4a53-a5b7-22af706875ab","type":"Grid"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"d11a77cb-4d38-4d8a-a381-1f8ec79afee9","type":"WheelZoomTool"},{"attributes":{"callback":null},"id":"ed99362c-9afb-4d81-b259-b4c1e1d85157","type":"DataRange1d"},{"attributes":{"below":[{"id":"38c71a03-03bf-4ce9-9823-2a8409a0e148","type":"LinearAxis"}],"left":[{"id":"cf7134df-96b3-49a8-8ced-ad0ae0d6b950","type":"LinearAxis"}],"renderers":[{"id":"38c71a03-03bf-4ce9-9823-2a8409a0e148","type":"LinearAxis"},{"id":"dbdb57f8-684f-4622-833b-264dac8a67d8","type":"Grid"},{"id":"cf7134df-96b3-49a8-8ced-ad0ae0d6b950","type":"LinearAxis"},{"id":"cf3964cd-1f7a-4a53-a5b7-22af706875ab","type":"Grid"},{"id":"219525fc-e8f6-4fe8-951a-a171e0484dde","type":"BoxAnnotation"},{"id":"4d9f32ba-2671-4008-b7f4-65ee0932b649","type":"Legend"},{"id":"0355c6cc-5472-4a3e-95cd-7426cec6bdcf","type":"GlyphRenderer"}],"title":"Legend Example","tool_events":{"id":"8829f7cc-df0c-48b0-92bf-fce2ce4a5705","type":"ToolEvents"},"tools":[{"id":"162bdef2-08ff-421c-bf34-78609a1a5676","type":"PanTool"},{"id":"d11a77cb-4d38-4d8a-a381-1f8ec79afee9","type":"WheelZoomTool"},{"id":"2196f39b-f32e-4362-b6cc-40a0e9b658c1","type":"BoxZoomTool"},{"id":"7fb152e8-19fc-4d65-ba24-eb6e7117e8b1","type":"PreviewSaveTool"},{"id":"d2ddc28b-bfda-4de3-ae05-2b4c16bea0a3","type":"ResizeTool"},{"id":"78b4b5b3-f7e1-49d6-b9e6-87b1ee953264","type":"ResetTool"},{"id":"83fea780-4d88-46c9-bacd-098fd950404f","type":"HelpTool"}],"x_range":{"id":"98625ef6-234a-4043-8838-560fa322f33d","type":"DataRange1d"},"y_range":{"id":"ed99362c-9afb-4d81-b259-b4c1e1d85157","type":"DataRange1d"}},"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"78b4b5b3-f7e1-49d6-b9e6-87b1ee953264","type":"ResetTool"},{"attributes":{"legends":[["Asin(x)",[{"id":"0355c6cc-5472-4a3e-95cd-7426cec6bdcf","type":"GlyphRenderer"}]]],"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"4d9f32ba-2671-4008-b7f4-65ee0932b649","type":"Legend"},{"attributes":{"overlay":{"id":"219525fc-e8f6-4fe8-951a-a171e0484dde","type":"BoxAnnotation"},"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"2196f39b-f32e-4362-b6cc-40a0e9b658c1","type":"BoxZoomTool"},{"attributes":{"plot":{"id":"0ebca398-23b6-4c26-8728-6d01e8c62ace","subtype":"Figure","type":"Plot"}},"id":"162bdef2-08ff-421c-bf34-78609a1a5676","type":"PanTool"},{"attributes":{},"id":"49aba325-e9fa-4ec1-b543-1f254dd2524e","type":"BasicTickFormatter"},{"attributes":{"data_source":{"id":"e65fa6d8-3a27-4b44-9ed2-947d42172992","type":"ColumnDataSource"},"glyph":{"id":"ccd9c5d0-9d20-4689-8b45-11caadba9b6f","type":"Circle"},"hover_glyph":null,"nonselection_glyph":{"id":"c55dab20-831d-41c3-8a8c-0163c5be0b35","type":"Circle"},"selection_glyph":null},"id":"0355c6cc-5472-4a3e-95cd-7426cec6bdcf","type":"GlyphRenderer"},{"attributes":{},"id":"5118cf7a-bb85-45fe-af9f-a7370014987a","type":"BasicTicker"},{"attributes":{},"id":"6fb3bb8b-5a9b-4867-be13-5030b5d888e7","type":"BasicTickFormatter"}],"root_ids":["0ebca398-23b6-4c26-8728-6d01e8c62ace"]},"title":"Bokeh Application","version":"0.11.1"}};
            var render_items = [{"docid":"95bcb163-355b-4659-8385-8f7c35eaf67c","elementid":"a462bc4d-b713-4c3f-83e0-e82905a4ef1b","modelid":"0ebca398-23b6-4c26-8728-6d01e8c62ace","notebook_comms_target":"96b91873-2e91-4f2c-9bf3-2265cac3d8f7"}];

            Bokeh.embed.embed_items(docs_json, render_items);
        });
      },
      function(Bokeh) {
      }
    ];

    function run_inline_js() {
      for (var i = 0; i < inline_js.length; i++) {
        inline_js[i](window.Bokeh);
      }
    }

    if (window._bokeh_is_loading === 0) {
      console.log("Bokeh: BokehJS loaded, going straight to plotting");
      run_inline_js();
    } else {
      load_libs(js_urls, function() {
        console.log("Bokeh: BokehJS plotting callback run at", now());
        run_inline_js();
      });
    }
  }(this));
</script>





<p><code>&lt;Bokeh Notebook handle for <strong>In[7]</strong>&gt;</code></p>
