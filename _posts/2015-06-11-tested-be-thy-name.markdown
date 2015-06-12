---
layout: post
title:  "Tested be thy name"
date:   2015-06-11 15:15:00
categories: ruby
---
People often talk about different types of tests, but it seems to be a bit hard
to keep track what each type of tests is supposed to do. I decided to create a short guide from a web developer's perspective.

The confusing part is that people often mix two different things. One is _testing level_ and the other is _testing type_. Another important thing is that you shouldn't assume we talk about writing automated tests here. Clicking inside a browser manually is also considered testing. Let's talk about testing levels first.


# Testing levels

The testing level describes how close to the code do we test. Are we interested in implementation details and what state is the system in or just the end results that a user can see?

**Unit tests** are the most basic one. They should test smallest unit of functionality, usually
a method. Any dependency that is non-trivial should be abstracted in some way.

**Integration tests** test larger chunks of application. They test how different components, each of which is tested individually with unit tests, interact with each other. Unlike unit tests integration tests
can and should access the database, filesystem and use other dependencies.

**System testing** or end-to-end testing is testing the system as a whole. In the web development world, this would mean clicking around in the browser and checking results.


# Testing types
Testing types don't really say anything about how we test, but rather why we test. Some types of testing make sense only on certain levels. However, it's important to note that testing types are unrelated to testing levels.

**Functional testing** should answer a question "Did we build a correctly working product?". It's why we write most of the tests, so this is a quite large group of tests.

**Acceptance testing** on the other hand should answer to the question "Are we building the right product?". Sometimes writing tests in Cucumber or similar tool is considered acceptance testing, because specs are written in a native language that customers can read. But generally acceptance testing means testing if the customer really needs the product you are building.

**Regression testing** is testing software regressions, which is a fancy way of saying "testing if we broke anything that previously worked". You probably do this all the time. When you run your automated test suite you are doing regression testing. There's no such thing as writing a regression test, every automated test is potentially a regression test.

**Smoke testing** sometimes called "sanity testing" is a name for a very quick and simple testing that does not go into a lot of details. This kind of tests is used to quickly check if something is badly broken, after which a full test suite should be run.

# Conclusion

This is just a fraction of all testing types that exist, I wrote about ones that I encountered most often. I have compiled this blog post from [Wikipedia](http://en.wikipedia.org/wiki/Software_testing) and [these](http://stackoverflow.com/questions/3370334/difference-between-acceptance-test-and-functional-test) [two](http://stackoverflow.com/questions/4904096/whats-the-difference-between-unit-functional-acceptance-and-integration-test) stack overflow questions, so you can read more about this topic there.
