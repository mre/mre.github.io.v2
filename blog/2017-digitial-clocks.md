extends: default.liquid

title:      Modern Day Annoyances - Digital Clocks
date:       7  Nov 2017 00:00:00 +0000
humandate:  7th of November 2017
path:       2017/digital-clocks
social_img: 2017_kitchen.png
---

This morning I woke up to the beeping noise of our oven's alarm clock.
The reason was that I tried to correct the oven's local time the day before &mdash; and I pushed the wrong buttons.
As a result I didn't set the correct time, instead, I set a cooking timer... and that's what woke me up today.

<figure>
   <div class="loader">
            <object data="/img/posts/2017/digital-clocks/kitchen.svg" type="image/svg+xml"></object>
            <img class="frozen" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAKCAMAAABcxfTLAAABMlBMVEX////9/Pbu7+bT2dP6+/rZ28309vX7/PzesarTmJHQkY32vJ775eT51rLxqnTHkmjhlV/ZjFf1pnuZlI1VZ2Shqajzx6v77PD0xLPPxGmx0LuxvnvLulrYul7x0bnty7LwzbLZrZTAoJDGnorxuG7ps2buu2Hvs2P1yInd17PX0Knxm3f705b67KvSy6L47LPd26vT12X87rb77rz0r4fdlWX1n3Dlh1zMc1m1ZVnklnXPiXnbkHndmXL1oHj4sE3umCT0myLEdV3CiHzEeG/vmCn1mhz0mhfxmi32r1H8zGnoph36sxiej4N4kZN4gYr0tjznpiH6tBPwsjj2ymv8zm3wrhr5sxiigXF9goSAfH/6tB31tzv5zm/z38LoxJPOopXIm5Pkv5bnxJPnw5fz3sG7JqVwAAAAM0lEQVR42q2HtQGAAADDElz+f5MNd9/YqFdQZ4jUHoTMFxURlN+f/35TtPn191Iyo1jYAHvfBr/hMFzjAAAAAElFTkSuQmCC" />
        </div>
  <figcaption>
  <a href="https://www.freepik.com/free-vector/kitchen-wall-interior_1311209.htm">Designed by Freepik</a>
  </figcaption>
</figure>

### Let's add a clock to the microwave!

On occasions like these, I wonder why there's a digital clock on every single household device these days.
They're integrated into microwaves, fridges, ovens, dishwashers, dryers, mixers &mdash; and that's just the kitchen!

There is an inflation of digital clocks on modern-day devices.
A lot of times I was wondering why that is the case. Here's my best guess:

*It's easier to add a useless digital clock to the design than to leave it out.*

Say you are the engineer responsible for the control panel of a run-of-the-mill microwave.
The microwave chip comes with a digital timer, which is perfect for showing the remaining time until the food is warmed up.
Now the question is, what will the timer show when you don't want to heat anything?

Well, why not show the current time?
It's unobtrusive and adds value.

Except that these digital clocks can be quite annoying:

- They run out of sync and show the wrong time.
- They get reset when being plugged off or there's a power outage. (That's the dreaded, blinking `00:00` we all learned to love.)
- They don't automatically switch between summer and winter time (hey Germany!).

That's why I constantly need to look after those clocks.

Let me tell you a secret:
When I'm not warming stuff in the oven, I don't want it to tell me the local time. I want the oven to be *off*.

### Why I have trouble setting the clock on our oven

[Our oven](http://aegelectrolux.co.za/cooking/ovens/dc4013001m-%C3%B0-multifunction-double-oven.html) has three buttons related to time: plus, minus and a clock symbol.
To set the time, you push the clock symbol. An arrow appears and the display changes to 00:00. You press time again and another arrow appears.
Pressing it two more times shows a blinking clock symbol. Then you can use the + and - buttons to adjust the time. After that, you wait to confirm.
Easy!

The problem is, there is no immediate relationship between the controls and the result in the world.
The underlying concept is called *mapping* and is prevalent in [interface design](https://en.wikipedia.org/wiki/Natural_mapping_(interface_design)).

To add some functionality to a device you have two options:

1. Add more buttons.
2. Teach an existing button a new trick.

Option 1 might dilute your beautiful design, while option 2 might mean frustration for your users.
Neither option is appealing.

Basically, our oven *maps* multiple functions to the same button.

But the most annoying thing is, that each device has *a different mapping*.
Learning to set the time on my oven won't help me with the dishwasher, which sports a totally different interface!

### Takeaways

**Good industry design is far and between.**

A clock on your product will most likely not add any additional value.
In the best case it might be an annoyance, in the worst case it's harmfully misleading.

When given the choice, I prefer home appliances without clocks.
Looking at today's market, that's harder than it sounds.
Arguably, a device with a clock is cheaper than one without. Simply because the ones with timers get produced more often.

Now I can understand why [it took Steve Jobs two weeks to decide on a washing machine](http://amzn.to/2AqQFZz):

> We spent some time in our family talking about what's the trade-off we want to make.
> We spent about two weeks talking about this. Every night at the dinner table

He chose a Miele Washing machine in the end - without a digital clock, I assume.