extends: default.liquid

title:      Lightning fast image previews with pure CSS
date:       11 Sep 2017 00:00:00 +0000
humandate:  11th of September 2017
path:       2017/css-delivery
social_img: 2017_makefiles.png
---

<figure>
  <div class="loader">
            <object data="/img/posts/2017/image-delivery/dog_mini.svg" type="image/svg+xml"></object>
            <img class="frozen" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAOCAMAAAAPOFwLAAABIFBMVEX////9/f3m5OLt7Ozb2NWaiHfEvbTMwLLby7fTvaPQrH62l2/n5+f7+/v8/Pzd2dTW0MfOq4DCnGzDnGu3lGi4lWvJycnDw8Po4tzYzsHJonKrlnuflou7uri2tLKampra2try/vP2//f7//v+///e3dv39vaZp6Vvb2+ioJ24tbD6+vrR+9bS+9fW+9rb/N/h/eTn/eru/fD2/vfJwrXTyLvYzL7h1MPPsYq5lWqGjIrFwZj4+PeyrYXKnme2m3T7//y9rH7KoGrJnWe8mGaotZHV/NnX/NvZ/N3f/OPh/OTd/OHa/N6607DEpXKxq4OusYq1t4+toXifon+zt5HT+9ivzK6mwaOuwZ2nw6K02bmivZ+erY2ltZXJ8c7e/OJUVqTIAAAAd0lEQVR42n3JM4JDUQCG0f8bdWPb8U6y6LBOFduo08X2fe+0B9kyNIwsmqOhdELfonXGQtfUF6x0TM3jqsta4BvIa+Y/JzkASGgFn8SeqLZ75RpJgqCMfc9Ap9ASz9B6YXxUf9/0Nwtpbbg37WEpZmgzN37ZuJsAt0cTudWVYOEAAAAASUVORK5CYII" />
        </div>
  <figcaption>
  A cute dog delivering a newspaper.<br />
<a href='http://www.freepik.com/free-vector/pack-of-four-hand-drawn-dogs_1080778.htm'>Dog</a> and 
  <a href='http://www.freepik.com/free-vector/newspaper-doodle-graphics_724010.htm'>newspaper</a>
  designed by Freepik.com.
  </figcaption>
</figure

As an avid reader of my blog, you know that I'm not a front-end developer.
The last Javascript library I used was &mdash; you guessed it &mdash; jQuery.
I'm proud to know the minimal amount of SASS and CSS to style my page without breaking all the browsers.

It's something I don't care much about.
One thing I *do* care about though is the web accessibility.

I take pride in the fact that my website is built on standards-compliant, semantically meaningful HTML5.
It should be readable by anyone.

Another thing I care about is website performance.
A page load should be snappy, even in areas, where broadband is not a given.

What I found is, that good accessibility and performance often go hand in hand.
As long as you stick to the standards, you're off to a good start.
This website uses plain old HTML, CSS, and SVG for illustrations. No JavaScript.




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