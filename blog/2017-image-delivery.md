extends: default.liquid

title:      Lightning fast image previews with pure CSS using LQIP
date:       18 Sep 2017 00:00:00 +0000
humandate:  18th of September 2017
path:       2017/image-delivery
social_img: 2017_image_delivery.png
---

<figure>
            <object data="/img/posts/2017/image-delivery/factory.svg" type="image/svg+xml"></object>
  <figcaption>
  Adapted from <a href="http://www.freepik.com/free-vector/industrial-machine-vector_753558.htm">Freepik</a>
  </figcaption>
</figure>

My website is reasonably fast. Every page load should be snappy, no matter the device or location.

That should not come as a surprise, after all I just use plain HTML and CSS.
I use JavaScript very sparingly.

One thing that annoyed me was layout reflow when images get loaded.

The problem is, that the image dimensions are not known when the text is ready to be displayed.
As a result, the text will be pushed down on the screen as soon as an image is loaded above.

Also, while an image is loading, there is no preview, just blank space.
Here's what that looks like on a slower connection:

<img src="/img/posts/2017/image-delivery/fout.gif" alt="Illustration of a flash of unstyled content">

I could fix that, by hardcoding the image width and height, which would be tedious and error-prone.

So I was wondering, what others are doing.
I vaguely remembered, that [Facebook uses tiny preview thumbnails in their mobile app](https://code.facebook.com/posts/991252547593574/the-technology-behind-preview-photos/).
They extract the quantization table from the JPEG header to render the preview. This information 
is stored on the client, so it doesn't need to be downloaded every time.
Unfortunately, this approach requires full control over the image encoder.
It works for apps, but hardly for websites.

The search continued.

My colleague [Tobias Baldauf](http://tobias.is/) introduced me to [LQIP (Low Quality Image Placeholders)](http://www.guypo.com/introducing-lqip-low-quality-image-placeholders/).

Here's the gist:

* Initially load the page with low quality images
* Once the page loaded (e.g. in the onload event), replace them with the full quality images

Unfortunately, this technique requires JavaScript.



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

* SQIP https://github.com/technopagan/sqip weighs in at 800-1000 bytes.