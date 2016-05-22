---
layout: post
title: Jupyter meets Jekyll CDN
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
import numpy as np
from bokeh.plotting import *
from bokeh.models import ColumnDataSource
from bokeh.resources import CDN
output_notebook(resources=CDN)
```


<div class="bk-banner">
    <a href="http://bokeh.pydata.org" target="blank" class="bk-logo bk-logo-small bk-logo-notebook"></a>
    <span id="e0db060d-12fa-4419-a197-fc05de19c976">Loading BokehJS ...</span>
</div>

## Now some bits of missing javascript need to be added
Initially this did not work with Bokeh, as not all of the javascript needed was being put onto the page.
By using nbconvert to output a html file we can see everything that Bokeh needs.

The following needed to be added to the head.html to load jquery and require.js.

```
<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.10/require.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
```

And this bit was found right after `output_notebook(resources=CDN)` but was not placed on the page when using `jupyter nbconvert <file> --to markdown`.

```
<div id="6067234a-281a-4c35-a1cb-2ba215ec9f5a"></div>
<div class="output_subarea output_javascript ">
<script type="text/javascript">
var element = $('#6067234a-281a-4c35-a1cb-2ba215ec9f5a');

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
  };

  var js_urls = ['https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.js', 'https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.js', 'https://cdn.pydata.org/bokeh/release/bokeh-compiler-0.11.1.min.js'];

  var inline_js = [
    function(Bokeh) {
      Bokeh.set_log_level("info");
    },

    function(Bokeh) {
      Bokeh.$("#865e097d-6e55-483e-8482-87f8f5d704d7").text("BokehJS successfully loaded");
    },
    function(Bokeh) {
      console.log("Bokeh: injecting CSS: https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.css");
      Bokeh.embed.inject_css("https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.css");
      console.log("Bokeh: injecting CSS: https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.css");
      Bokeh.embed.inject_css("https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.css");
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
</div>

</div>
```

<div id="6067234a-281a-4c35-a1cb-2ba215ec9f5a"></div>
<div class="output_subarea output_javascript ">
<script type="text/javascript">
var element = $('#6067234a-281a-4c35-a1cb-2ba215ec9f5a');

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
  };

  var js_urls = ['https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.js', 'https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.js', 'https://cdn.pydata.org/bokeh/release/bokeh-compiler-0.11.1.min.js'];

  var inline_js = [
    function(Bokeh) {
      Bokeh.set_log_level("info");
    },

    function(Bokeh) {
      Bokeh.$("#865e097d-6e55-483e-8482-87f8f5d704d7").text("BokehJS successfully loaded");
    },
    function(Bokeh) {
      console.log("Bokeh: injecting CSS: https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.css");
      Bokeh.embed.inject_css("https://cdn.pydata.org/bokeh/release/bokeh-0.11.1.min.css");
      console.log("Bokeh: injecting CSS: https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.css");
      Bokeh.embed.inject_css("https://cdn.pydata.org/bokeh/release/bokeh-widgets-0.11.1.min.css");
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
</div>

</div>

```python
x = np.linspace(0, 4*np.pi, 100)
y = np.sin(x)

source = ColumnDataSource(dict(x=x,y=y))

p1 = figure(title="Legend Example")
p1.circle(x, y, source=source, legend="Asin(x)")
```




    <bokeh.models.renderers.GlyphRenderer at 0x2489a30>




```python
def update(A=1):
    source.data['y'] = A * np.sin(source.data['x'])
    source.push_notebook()
```


```python
show(p1)  # open a browser    
```




<div class="plotdiv" id="a67aafe6-91db-4e75-ba50-e21f1e511ae6"></div>
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
    };var element = document.getElementById("a67aafe6-91db-4e75-ba50-e21f1e511ae6");
    if (element == null) {
      console.log("Bokeh: ERROR: autoload.js configured with elementid 'a67aafe6-91db-4e75-ba50-e21f1e511ae6' but no matching script tag was found. ")
      return false;
    }

    var js_urls = [];

    var inline_js = [
      function(Bokeh) {
        Bokeh.$(function() {
            var docs_json = {"cc485ab5-281e-4ad4-a0a7-121e1c7f8d67":{"roots":{"references":[{"attributes":{"legends":[["Asin(x)",[{"id":"d6385619-da67-4a8f-a8d5-52d56cc7ead4","type":"GlyphRenderer"}]]],"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"dd9fb2af-6df7-40c4-a902-78dec003220d","type":"Legend"},{"attributes":{"formatter":{"id":"88d8032c-00bf-44f6-92fe-0a32e0ae10f4","type":"BasicTickFormatter"},"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"},"ticker":{"id":"d02dd2a6-1fc3-419e-86e2-8a297dd72147","type":"BasicTicker"}},"id":"77bf1f43-5ee8-4923-919d-c411eecf9a60","type":"LinearAxis"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"2be17e44-fbb8-47ab-9134-702a7e64fbbb","type":"WheelZoomTool"},{"attributes":{"fill_alpha":{"value":0.1},"fill_color":{"value":"#1f77b4"},"line_alpha":{"value":0.1},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"7f087593-b1da-46e3-95dd-53c340a82f37","type":"Circle"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"5c3792d7-e84d-4c25-a199-15fa195d38ed","type":"HelpTool"},{"attributes":{},"id":"b19db507-9286-47ce-b06e-8b6077140390","type":"BasicTicker"},{"attributes":{"bottom_units":"screen","fill_alpha":{"value":0.5},"fill_color":{"value":"lightgrey"},"left_units":"screen","level":"overlay","line_alpha":{"value":1.0},"line_color":{"value":"black"},"line_dash":[4,4],"line_width":{"value":2},"plot":null,"render_mode":"css","right_units":"screen","top_units":"screen"},"id":"dff6d4af-b85f-45e4-8cec-6bed62ccb960","type":"BoxAnnotation"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"d8e5f135-0eb4-42c4-9d63-ce52b557cf15","type":"PanTool"},{"attributes":{"callback":null},"id":"bdae39c9-cd8d-4515-a3de-d8407810b17c","type":"DataRange1d"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"fe73d867-d938-4e2d-a99e-ead895d661d5","type":"PreviewSaveTool"},{"attributes":{"data_source":{"id":"cd4596fd-28a8-4378-88d7-903353e97482","type":"ColumnDataSource"},"glyph":{"id":"6e31122c-efb5-4b36-936f-63603698e905","type":"Circle"},"hover_glyph":null,"nonselection_glyph":{"id":"7f087593-b1da-46e3-95dd-53c340a82f37","type":"Circle"},"selection_glyph":null},"id":"d6385619-da67-4a8f-a8d5-52d56cc7ead4","type":"GlyphRenderer"},{"attributes":{},"id":"d02dd2a6-1fc3-419e-86e2-8a297dd72147","type":"BasicTicker"},{"attributes":{},"id":"88d8032c-00bf-44f6-92fe-0a32e0ae10f4","type":"BasicTickFormatter"},{"attributes":{},"id":"e1ca2216-6bc5-4172-b712-44bf5e4aa35b","type":"BasicTickFormatter"},{"attributes":{"formatter":{"id":"e1ca2216-6bc5-4172-b712-44bf5e4aa35b","type":"BasicTickFormatter"},"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"},"ticker":{"id":"b19db507-9286-47ce-b06e-8b6077140390","type":"BasicTicker"}},"id":"72ea68d5-aff4-4ed9-a55b-b448693e1f40","type":"LinearAxis"},{"attributes":{"callback":null,"column_names":["y","x","y","x"],"data":{"x":[0.0,0.12693303650867852,0.25386607301735703,0.3807991095260356,0.5077321460347141,0.6346651825433925,0.7615982190520711,0.8885312555607496,1.0154642920694281,1.1423973285781066,1.269330365086785,1.3962634015954636,1.5231964381041423,1.6501294746128208,1.7770625111214993,1.9039955476301778,2.0309285841388562,2.1578616206475347,2.284794657156213,2.4117276936648917,2.53866073017357,2.6655937666822487,2.792526803190927,2.9194598396996057,3.0463928762082846,3.173325912716963,3.3002589492256416,3.42719198573432,3.5541250222429985,3.681058058751677,3.8079910952603555,3.934924131769034,4.0618571682777125,4.188790204786391,4.3157232412950695,4.442656277803748,4.569589314312426,4.696522350821105,4.823455387329783,4.950388423838462,5.07732146034714,5.204254496855819,5.331187533364497,5.458120569873176,5.585053606381854,5.711986642890533,5.838919679399211,5.96585271590789,6.092785752416569,6.219718788925247,6.346651825433926,6.473584861942604,6.600517898451283,6.727450934959961,6.85438397146864,6.981317007977318,7.108250044485997,7.235183080994675,7.362116117503354,7.489049154012032,7.615982190520711,7.742915227029389,7.869848263538068,7.996781300046746,8.123714336555425,8.250647373064103,8.377580409572783,8.50451344608146,8.631446482590139,8.758379519098817,8.885312555607497,9.012245592116175,9.139178628624853,9.266111665133531,9.39304470164221,9.519977738150889,9.646910774659567,9.773843811168245,9.900776847676925,10.027709884185603,10.15464292069428,10.28157595720296,10.408508993711639,10.535442030220317,10.662375066728995,10.789308103237675,10.916241139746353,11.04317417625503,11.170107212763709,11.297040249272388,11.423973285781067,11.550906322289745,11.677839358798423,11.804772395307102,11.93170543181578,12.058638468324459,12.185571504833138,12.312504541341816,12.439437577850494,12.566370614359172],"y":[0.0,0.12659245357374926,0.2511479871810792,0.3716624556603276,0.4861967361004687,0.5929079290546404,0.690079011482112,0.7761464642917568,0.8497254299495144,0.9096319953545183,0.9549022414440739,0.984807753012208,0.998867339183008,0.9968547759519424,0.9788024462147787,0.9450008187146685,0.8959937742913359,0.8325698546347714,0.7557495743542583,0.6667690005162917,0.5670598638627709,0.4582265217274105,0.3420201433256689,0.2203105327865408,0.09505604330418244,-0.03172793349806786,-0.15800139597335008,-0.28173255684142984,-0.4009305354066138,-0.5136773915734064,-0.6181589862206053,-0.7126941713788629,-0.7957618405308321,-0.8660254037844388,-0.9223542941045814,-0.9638421585599422,-0.9898214418809327,-0.9998741276738751,-0.9938384644612541,-0.9718115683235417,-0.9341478602651068,-0.881453363447582,-0.8145759520503358,-0.7345917086575332,-0.6427876096865396,-0.5406408174555974,-0.4297949120891719,-0.31203344569848707,-0.18925124436040974,-0.06342391965656452,0.06342391965656492,0.18925124436041013,0.31203344569848745,0.4297949120891715,0.5406408174555978,0.6427876096865391,0.7345917086575334,0.8145759520503356,0.8814533634475821,0.9341478602651067,0.9718115683235418,0.9938384644612541,0.9998741276738751,0.9898214418809328,0.963842158559942,0.9223542941045816,0.8660254037844383,0.7957618405308319,0.7126941713788629,0.6181589862206056,0.5136773915734058,0.40093053540661344,0.2817325568414299,0.15800139597335056,0.03172793349806701,-0.09505604330418282,-0.22031053278654034,-0.342020143325668,-0.45822652172741085,-0.5670598638627707,-0.6667690005162913,-0.7557495743542588,-0.8325698546347716,-0.8959937742913359,-0.9450008187146683,-0.9788024462147789,-0.9968547759519424,-0.998867339183008,-0.9848077530122081,-0.9549022414440737,-0.9096319953545183,-0.8497254299495145,-0.7761464642917573,-0.6900790114821116,-0.5929079290546404,-0.48619673610046904,-0.3716624556603267,-0.2511479871810788,-0.1265924535737493,-4.898587196589413e-16]}},"id":"cd4596fd-28a8-4378-88d7-903353e97482","type":"ColumnDataSource"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"f73fa045-5998-4b26-aaac-52f673a74ea2","type":"ResetTool"},{"attributes":{"dimension":1,"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"},"ticker":{"id":"d02dd2a6-1fc3-419e-86e2-8a297dd72147","type":"BasicTicker"}},"id":"1696e80f-4c94-40b8-9515-c7076e914f0f","type":"Grid"},{"attributes":{"fill_color":{"value":"#1f77b4"},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"6e31122c-efb5-4b36-936f-63603698e905","type":"Circle"},{"attributes":{"below":[{"id":"72ea68d5-aff4-4ed9-a55b-b448693e1f40","type":"LinearAxis"}],"left":[{"id":"77bf1f43-5ee8-4923-919d-c411eecf9a60","type":"LinearAxis"}],"renderers":[{"id":"72ea68d5-aff4-4ed9-a55b-b448693e1f40","type":"LinearAxis"},{"id":"016cc1ad-e8f5-440a-ba70-9db50817b262","type":"Grid"},{"id":"77bf1f43-5ee8-4923-919d-c411eecf9a60","type":"LinearAxis"},{"id":"1696e80f-4c94-40b8-9515-c7076e914f0f","type":"Grid"},{"id":"dff6d4af-b85f-45e4-8cec-6bed62ccb960","type":"BoxAnnotation"},{"id":"dd9fb2af-6df7-40c4-a902-78dec003220d","type":"Legend"},{"id":"d6385619-da67-4a8f-a8d5-52d56cc7ead4","type":"GlyphRenderer"}],"title":"Legend Example","tool_events":{"id":"ffe807f0-1b1e-41c7-8a23-937cc57c19bf","type":"ToolEvents"},"tools":[{"id":"d8e5f135-0eb4-42c4-9d63-ce52b557cf15","type":"PanTool"},{"id":"2be17e44-fbb8-47ab-9134-702a7e64fbbb","type":"WheelZoomTool"},{"id":"a395f42e-f334-4a1f-aed0-b5ba881d3f67","type":"BoxZoomTool"},{"id":"fe73d867-d938-4e2d-a99e-ead895d661d5","type":"PreviewSaveTool"},{"id":"632db3cb-9794-4541-8fc6-3247b6410a42","type":"ResizeTool"},{"id":"f73fa045-5998-4b26-aaac-52f673a74ea2","type":"ResetTool"},{"id":"5c3792d7-e84d-4c25-a199-15fa195d38ed","type":"HelpTool"}],"x_range":{"id":"bdae39c9-cd8d-4515-a3de-d8407810b17c","type":"DataRange1d"},"y_range":{"id":"e90c4fa5-d143-4426-b240-e708f42b5ce6","type":"DataRange1d"}},"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"},{"attributes":{},"id":"ffe807f0-1b1e-41c7-8a23-937cc57c19bf","type":"ToolEvents"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"},"ticker":{"id":"b19db507-9286-47ce-b06e-8b6077140390","type":"BasicTicker"}},"id":"016cc1ad-e8f5-440a-ba70-9db50817b262","type":"Grid"},{"attributes":{"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"632db3cb-9794-4541-8fc6-3247b6410a42","type":"ResizeTool"},{"attributes":{"overlay":{"id":"dff6d4af-b85f-45e4-8cec-6bed62ccb960","type":"BoxAnnotation"},"plot":{"id":"71332212-4d80-44b9-9bef-2b33822cfe60","subtype":"Figure","type":"Plot"}},"id":"a395f42e-f334-4a1f-aed0-b5ba881d3f67","type":"BoxZoomTool"},{"attributes":{"callback":null},"id":"e90c4fa5-d143-4426-b240-e708f42b5ce6","type":"DataRange1d"}],"root_ids":["71332212-4d80-44b9-9bef-2b33822cfe60"]},"title":"Bokeh Application","version":"0.11.1"}};
            var render_items = [{"docid":"cc485ab5-281e-4ad4-a0a7-121e1c7f8d67","elementid":"a67aafe6-91db-4e75-ba50-e21f1e511ae6","modelid":"71332212-4d80-44b9-9bef-2b33822cfe60","notebook_comms_target":"38829ecf-7a8d-4bb9-9080-360a319dedf0"}];

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





<p><code>&lt;Bokeh Notebook handle for <strong>In[5]</strong>&gt;</code></p>
