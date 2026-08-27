# S²E Lab Website

Website for the **Security and Software Engineering (S²E) Lab** at the University of Notre Dame.

- Production site: [s2elab.org](https://s2elab.org)
- GitHub Pages URL: [s2e-lab.github.io](https://s2e-lab.github.io)
- Repository: [github.com/s2e-lab/s2e-lab.github.io](https://github.com/s2e-lab/s2e-lab.github.io)



## Design provenance

The visual direction was inspired by [Maksim Smirnov's terminal-style site](https://smirnoffmg.dev). The original Harvard-style CV theme was discovered through its [Jekyll Themes listing](https://jekyll-themes.com/smirnoffmg/harvard-style-cv-theme) and is available from the [upstream GitHub repository](https://github.com/smirnoffmg/harvard-style-cv-theme).

The S²E site is not configured as a `remote_theme` and does not use the upstream CV data model. It is a custom lab-oriented implementation that preserves this repository's existing Jekyll pages and structured research data. The upstream theme is distributed under the MIT License and is copyright © 2025 Maksim Smirnov.

## Local development

### Requirements

- Ruby
- Bundler
- Git

Install the Ruby dependencies:

```sh
bundle install
```

Start the development server with live reload:

```sh
./run.sh
```

Arguments are forwarded to Jekyll, so a different port can be selected with:

```sh
./run.sh --port 4001
```

Alternatively, run Jekyll directly:

```sh
bundle exec jekyll serve --livereload
```

Open `http://localhost:4000` in a browser.

### Production build

Generate the static site in `_site/`:

```sh
bundle exec jekyll build
```

The `_site/` directory is generated output and must not be edited or committed. Change the corresponding source file and rebuild instead.

## Repository structure

| Path | Purpose |
| --- | --- |
| `_config.yml` | Global site configuration, URLs, contact details, collections, and build settings. |
| `_data/` | Structured metadata for members, publications, and software artifacts. See [`_data/README.md`](_data/README.md). |
| `_includes/` | Reusable page fragments such as navigation, header, footer, member cards, and publication details. |
| `_layouts/` | Jekyll layouts used by pages, posts, projects, and questions. |
| `_posts/` | Dated news and publication announcements. |
| `assets/` | Stylesheets, scripts, images, fonts, member photos, and downloadable visual assets. |
| `preprints/` | Locally hosted publication preprints and their index. |
| `index.html` | Homepage dashboard and its Jekyll data queries. |
| `members.html` | Members page assembled from `_data/members.yml`. |
| `publications.html` | Publications page assembled from `_data/publications.yml`. |
| `artifacts.html` | Software and datasets page assembled from `_data/artifacts.yml`. |
| `blog.html` | News archive assembled from `_posts/`. |
| `join.html` | Lab recruiting and application guidance. |
| `CNAME` | Custom domain used by GitHub Pages. |
| `run.sh` | Convenience script for the local live-reload server. |

## Site configuration

Global settings live in `_config.yml`. Restart the local Jekyll server after changing this file; Jekyll does not reliably reload configuration changes while running.

### Identity and URLs

| Setting | Description |
| --- | --- |
| `title` | Site name used in browser titles. |
| `description` | Short site description for metadata and integrations. |
| `url` | Canonical origin without a trailing slash. Production uses `https://s2e-lab.github.io`. |
| `baseurl` | Subpath below the domain. Keep empty when publishing at the domain root; otherwise begin with `/`. |
| `github_username` | GitHub organization or account name. |
| `github_repo` | Repository name. |
| `analytics` | Optional analytics identifier. Leave blank to disable the analytics snippet. |

Use `{{ site.baseurl }}` when creating internal asset or page URLs so the site continues to work if it is later hosted below a subpath:

```liquid
<a href="{{ "/members/" | prepend: site.baseurl }}">Members</a>
<img src="{{ "/assets/img/example.png" | prepend: site.baseurl }}" alt="Description">
```

### Contact and footer metadata

| Setting | Description |
| --- | --- |
| `social` | Social profiles rendered in the footer. Each entry has `title` and `url`. |
| `address` | Postal-address lines used by pages that display the lab location. |
| `email` | Primary contact address used by the footer and contact links. |
| `tel` | Lab telephone number. |
| `about` | Short lab description available as `site.about`. |

### Content processing

- Markdown is rendered with Kramdown using GitHub-Flavored Markdown input.
- Code highlighting uses Rouge.
- Post URLs follow `/:categories/:title/`.
- `<!--more-->` marks the end of a post excerpt when an explicit `excerpt` is not provided.
- The `projects` and `questions` collections emit standalone pages.
- `teaching/sse-book/build/_assets` is explicitly included in generated output.

The legacy `colors` values in `_config.yml` are still referenced by some older Bootstrap-based components. The command-center interface uses CSS custom properties documented under [Styling](#styling).

## Structured data

Content shared across multiple pages belongs in `_data/` rather than being duplicated in templates:

- `_data/members.yml` controls people and member photographs.
- `_data/publications.yml` controls publication metadata, citations, links, and resources.
- `_data/artifacts.yml` controls software and dataset listings.

Field-level schemas and examples are maintained separately in [`_data/README.md`](_data/README.md). When adding or changing a YAML schema, update that README as part of the same change.

## Pages and front matter

Every Jekyll page begins with YAML front matter. A typical page looks like:

```yaml
---
layout: default
title: Example Page
permalink: /example/
---
```

| Field | Description |
| --- | --- |
| `layout` | Layout from `_layouts/`, without the `.html` extension. |
| `title` | Browser-title suffix, navigation state, and default page heading. |
| `permalink` | Stable public URL. Prefer leading and trailing slashes for site pages. |
| `wrap_title` | Optional heading override used by `_includes/wrap.html`. |

Add a navigation item in `_includes/nav.html` only when it belongs in the global primary navigation. Use `site.baseurl` for internal links and preserve the terminal-style bracket notation used by the current navigation.

## News posts

Posts live in `_posts/` and must use the Jekyll filename format:

```text
YYYY-MM-DD-descriptive-slug.md
```

Recommended front matter:

```yaml
---
layout: post
title: "Full announcement title"
short_title: "Compact homepage activity title"
date: 2026-01-01 12:00:00 -0500
categories: paper research
author: "Author Name"
paper_id: publication-key
excerpt: "One- or two-sentence summary."
---
```

| Field | Required | Description |
| --- | --- | --- |
| `layout` | Yes | Normally `post`. |
| `title` | Yes | Full post title. |
| `date` | Yes | Controls sorting and the public URL. Include the time zone. |
| `categories` | Recommended | Used in post permalinks and category archives. |
| `author` | Recommended | Displayed in post and blog metadata. |
| `short_title` | Recommended | Compact label in `LATEST_ACTIVITY.LOG`; the homepage falls back to `title`. |
| `excerpt` | Recommended | Summary displayed by the blog archive. |
| `paper_id` | Optional | Key matching a publication in `_data/publications.yml`; adds publication details to the post. |
| `img` | Optional | Image filename relative to `assets/img/blog/`. |

The five newest posts automatically appear in the homepage activity panel.

## Homepage data flow

The homepage is intentionally data-driven:

- `LATEST_ACTIVITY.LOG` uses the five newest items in `site.posts`.
- `MEET THE LAB` draws portraits from the `professors`, `postdocs`, and `graduates` sections of `_data/members.yml`.
- Publication and software calls to action link to their full data-driven pages.
- Research focus labels and mission text currently live directly in `index.html`.

To change homepage layout or copy, edit `index.html`. To change the shared hero, navigation, or footer, edit `_includes/header.html`, `_includes/nav.html`, or `_includes/footer.html` respectively.

## Styling

The compiled stylesheet is `assets/css/main.css`. Its source is assembled by Jekyll from `_layouts/main.css` and `_includes/css/main.css`; make design changes in `_includes/css/main.css` rather than editing generated files under `_site/`.

The command-center palette is defined with CSS custom properties:

```css
--console-bg: #080d12;
--console-panel: #0c141b;
--console-text: #e8e9e7;
--console-muted: #87929c;
--console-gold: #c99700;
--console-blue: #55b9db;
--console-green: #85d36b;
```

Reusable helpers include:

```html
<span class="text-gold">Gold text</span>
```

The interface uses Space Grotesk for primary text, Oswald for display headings, and IBM Plex Mono for terminal labels and metadata. Maintain readable body typography and use monospace selectively.

When adding animation, honor the existing `prefers-reduced-motion` rules. Interactive elements must retain visible hover and keyboard-focus states with sufficient contrast.

## Images and other assets

- Place member portraits in `assets/img/members/` and reference only the filename from `_data/members.yml`.
- Place blog images in `assets/img/blog/` and reference only the filename from post front matter.
- Give informative images meaningful `alt` text. Use an empty `alt` attribute only for genuinely decorative images.
- Optimize large images before committing them; avoid shipping the same photograph in multiple unnecessary formats.
- Add publication manuscripts to `preprints/` only when the lab is authorized to distribute them.

## Deployment

The repository is compatible with the `github-pages` gem declared in `Gemfile`. Updates pushed to the publishing branch are built and served by GitHub Pages according to the repository's Pages settings.

The custom domain is configured in `CNAME`:

```text
s2elab.org
```

Do not remove or rename `CNAME` unless the production-domain configuration is intentionally changing. DNS and the repository's GitHub Pages settings must agree with this value.

Before publishing:

```sh
bundle exec jekyll build
git diff --check
```

Then review at least the homepage and the page affected by the change at desktop and mobile widths.

## Maintenance checklist

1. Edit source content, structured YAML, includes, or styles—not `_site/`.
2. Update `_data/README.md` when a structured-data field or category changes.
3. Keep internal links compatible with `site.baseurl`.
4. Preserve stable permalinks for public pages and posts.
5. Build locally and fix all Jekyll errors.
6. Check navigation, contrast, mobile overflow, images, and keyboard focus.
7. Verify external URLs and downloadable files before publishing.

## Troubleshooting

### Configuration changes are not appearing

Stop and restart the Jekyll server after editing `_config.yml`.

### A member photograph is missing

Confirm that the `img` value in `_data/members.yml` exactly matches a filename in `assets/img/members/`, including capitalization and extension.

### Publication details are missing from a post

Confirm that the post's `paper_id` exactly matches a publication key in `_data/publications.yml`.

### A page works locally but not below a subpath

Check that internal URLs are built with `site.baseurl` rather than hard-coded relative paths.

### The local dependency set is inconsistent

Run `bundle install` and use `bundle exec` for Jekyll commands so the versions in `Gemfile.lock` are respected.
