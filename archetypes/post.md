---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true

description: "<text>"
summary: "<text>"
tags: []

cover:
    image: "<image path/url>" # image path/url
    alt: "<text>"
    caption: "<text>"
    relative: false # when using page bundles set this to true
---