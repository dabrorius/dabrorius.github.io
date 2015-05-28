---
layout: post
title:  "How I released my first iOS app"
date:   2015-05-25 21:12:09
categories:
---

Few days ago I released my first iOS app, it's a cat petting simulator called "[CatMe](https://youtu.be/aa52iHSSqNk)"
. It's already available on [app store](https://itunes.apple.com/us/app/id994659934), but 
I wanted to share few thoughts about building it.

I started writing the app back in 2014., for me it was just a way to learn Swift
and native iOS development. I wanted to build an example app which is simple but still
unique and fun enough to get approved for the app store. The plan was to just
build an application with pictures of cats, which seemed awesome enough by itself.
However after I built a prototype the cat was so cute that I wanted to pet it through
screen, so that's how I got the idea for the final version of the app.

I stopped developing it after a week because I couldn't find high-quality royalty-free
pictures of cats (trust me, it's harder than you think). However after I got a lot of positive
feedback in following months, I decided to start working on it again.[Vanessa](https://www.behance.net/vanessazoyd) helped me finally find some good cat photos
and she also designed [this awesome icon](https://www.behance.net/gallery/26008671/CatMe-App-Icon).

Before I started learning native iOS development I had a few ventures into hybrid
application development. I didn't work on any serious projects, but I spent some
time reading tutorials and attempting to write apps in various JS frameworks and I
didn't really like it. It just felt wrong and required a lot of hacks to get a mobile
app feel.

Native app development felt really refreshing, all basic components were there.
You don't need to download some obscure third party slider that works well on touch
devices - there's a cocoa touch component for that - and it's easier to use. I really
love the snappy feel of sliders on touch devices. (That's one of the main reasons
I started learning iOS app development. :D)

It turns out that the web and mobile app development are quite different and using 
tools that were meant to be used for mobile app development makes things easier, and not
harder as some may try to convince you. The only reason I see for building hybrid mobile applications is laziness to learn new toolchain and language. Oh yeah, and cross-platform
development, even though if you really want to build a high-quality experience you should
build multiple apps anyway.

I like Swift as a language, it's definitely more friendly to newcomers then
Objective-C. It feels modern and reliable, and it integrates with Objective-C quite
well.

One thing I didn't really like is Storyboards. They are not bad, but there are some
issues. One thing is that they are huge and take up a lot of space, even on a 24" screen.
I can't even imagine trying to use them on my 15" laptop screen. To make things worse
zooming in and out of them is really weird and/or glitchy. Another problem is that
they are a bit magical. You can build things without fully understanding what's going
on behind the scene, which is nice when you just try get something done, but I bet
it would become a problem in the long run.

Fortunately, you can build a complete application without using Storyboards (or Interface builder) by just using Cocoa API. And to make things even better, it's considered
best practice.

People are reacting really well to the application so far. Some of them find it
hilarious, some even think that it's a critique of the current state of App store,
but all agree that the world needs more cats in every aspect of our lives.
