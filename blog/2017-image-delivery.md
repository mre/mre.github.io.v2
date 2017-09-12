extends: default.liquid

title:      Lightning fast image previews with pure CSS
date:       11 Sep 2017 00:00:00 +0000
humandate:  11th of September 2017
path:       2017/css-delivery
social_img: 2017_makefiles.png
---

As an avid reader of this blog, you know that I'm not a front-end developer.
Apart from the basic concepts, things like React or Angular are completely foreign to me.
The last Javascript library I used was &mdash; you guessed it &mdash; jQuery.

It's just something I don't care about.
One thing I *do* care about though, is the *semantic* web.
I take proud in the fact that my page is using valid, standards-compliant HTML5.

Another thing I care about is website performance.
A page load should be snappy.

A way to combine both, good performance and valid structure is to keep things simple.
This website is just plain old HTML, CSS, and mostly SVG for illustrations.
As a side-effect this make my writing barrier-free.

<figure>
    <object data="/img/posts/2017/image-delivery/dog.svg" type="image/svg+xml"></object>
  <figcaption>
  A cute dog delivering a newspaper.
<a href='http://www.freepik.com/free-vector/pack-of-four-hand-drawn-dogs_1080778.htm'>Dog</a> and 
  <a href='http://www.freepik.com/free-vector/newspaper-doodle-graphics_724010.htm'>newspaper</a>
  designed by Freepik.com.
  </figcaption>
</figure


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