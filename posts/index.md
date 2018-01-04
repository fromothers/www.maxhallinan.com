---
layout: base
title: Posts
---

## Posts

{% for post in site.categories.posts %}
  - {{post.date | date_to_string }} - [{{post.title}}]({{post.url}})
{% endfor %}
