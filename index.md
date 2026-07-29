---
permalink: /
title: ""
excerpt: "Pengzhu LIN, Research Assistant Professor at HKUST MAE"
author_profile: false
classes:
  - home
redirect_from:
  - /about/
  - /about.html
---

{% if site.website_visibility == "public" %}

<div class="home-shell">

{% include home/intro.md %}

{% include home/news.md %}

{% include home/pub_short.md %}

{% include home/others.md %}

</div>

{% else %}

<section class="site-paused" aria-label="Website unavailable">
  <div class="site-paused__inner">
    <p class="site-paused__eyebrow">Pengzhu Lin</p>
    <h1>Website temporarily unavailable</h1>
    <p>This personal webpage is currently offline.</p>
    <p>For correspondence, please contact <a href="mailto:mepengzhul@ust.hk">mepengzhul@ust.hk</a>.</p>
  </div>
</section>

{% endif %}
