extends: default.liquid

title:      Lightning fast image previews with pure CSS
date:       11 Sep 2017 00:00:00 +0000
humandate:  11th of September 2017
path:       2017/css-delivery
social_img: 2017_makefiles.png
---

<figure>
    <object data="/img/posts/2017/image-delivery/dog.svg" type="image/svg+xml"></object>
  <figcaption>
  A cute dog delivering a newspaper.<br />
<a href='http://www.freepik.com/free-vector/pack-of-four-hand-drawn-dogs_1080778.htm'>Dog</a> and 
  <a href='http://www.freepik.com/free-vector/newspaper-doodle-graphics_724010.htm'>newspaper</a>
  designed by Freepik.com.
  </figcaption>
</figure

As an avid reader of this blog, you know that I'm not a front-end developer.
The last Javascript library I used was &mdash; you guessed it &mdash; jQuery.
I'm proud to know the minimal amount of SASS and CSS to style my page without breaking all the browsers.

It's just something I don't care about.
One thing I *do* care about though, is the web accessability.

I take pride in the fact that my website is built on standards-compliant, semantically meaningful HTML5.
It should be readable by anyone.

Another thing I care about is website performance.
A page load should be snappy, even in areas, where broadband is not a given.

What I found is, that good accessability and performance often go hand in hand.
As long as you stick to the standards, you're off for a good start.
This website is just using plain old HTML, CSS, and mostly SVG for illustrations.
It uses no JavaScript.




Prevent reflow.

### Requirements

* No JavaScript.
* It needs to support both SVG and JPEG.
* It should be standards-compliant and work on all modern browsers.
* It should provide a fallback in case the main image cannot be loaded.
* It should not have much overhead.

Tried webp
It's only available on Chrome.
Might be an addition for later.

https://jmperezperez.com/medium-image-progressive-loading-placeholder/


The actual code to create the images is rather boring.
If you *really* want to have a look, [I've pushed it to Github](https://github.com/mre/lqip/).

Todo:
* make the animation longer for devices with low bandwidth. There's [no way to check connection speed with CSS](https://css-tricks.com/bandwidth-media-queries/), but
we could assume that users with smaller screens are using mobile devices. Many of them might be browsing the web on their
mobile data plans using weaker connections. Therefore, we could use media queries to extend the animation on mobile devices.