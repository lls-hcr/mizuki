---
# Page settings
layout: default # Choose layout: "default", "homepage" or "documentation-archive"
title: Just testing # Define a title of your page
description: This is a test... not yet ready for publishing # Define a description of your page
keywords: # Define keywords for search engines
comments: false # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"
---



<h1>Latest Posts</h1>

 <ul>
   {% for post in site.posts %}
     <li>
       <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
       <span style="color:red">{{ post.date | date:"%d %b" }}</span>
       {{ post.excerpt }}
     </li>
   {% endfor %}
 </ul>