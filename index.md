---
# Page settings
layout: homepage # Choose layout: "default", "homepage" or "documentation-archive"
title: # Define a title of your page
description: # Define a description of your page
keywords: # Define keywords for search engines

# Hero section
hero:
    title: Hero section — Title
    text: Hero section — Text
    background_image: # Paste image URL to display image in background of hero section
    buttons: # Add buttons below, there are examples with all available options
        - label: Button — Filled with icon
          url: http://example.com
          external_url: true # Set to "false" if you're pointing to inner page
          style: filled # Choose style: "filled" or "bordered"
          icon: github # Choose from 266 icons in "Feather" icon set, list of all icons is available here - https://feathericons.com
        - label: Button — Bordered with icon
          url: /documentation
          external_url: false
          style: bordered
          icon: gitlab
    download_link: # Set small download link placed below buttons
        label: Download — v4.0.0
        url: https://example.com

# Features section
features:
    rows: # Add feature rows below, there are examples with all available options
        - title: Features row 1 — Title
          description: Features row 1 — Description
          grid: # Add feature grid items below, there are examples with all available options
              - title: Feature 1 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: box # Choose from 266 icons in "Feather" icon set, list of all icons is available here - https://feathericons.com
              - title: Feature 2 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: server
              - title: Feature 3 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: cpu
        - title: Features row 2 — Title
          description: Features row 2 — Description
          grid:
              - title: Feature 1 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: git-branch
              - title: Feature 2 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: git-commit
              - title: Feature 3 — Title
                description: Lorem ipsum, dolor sit amet consectetur adipisicing elit. Provident iste voluptas sunt eligendi sit dolorem blanditiis nostrum, fuga ducimus enim? Ut temporibus.
                icon: git-merge
    footer: # Set features section footer variables
        title: Features footer — Title
        description: Features footer — Description
        buttons: # Add buttons below, there are examples with all available options
            - label: Button — Filled
              url: http://example.com
              external_url: true # Set to "false" if you're pointing to inner page
              style: filled # Choose style: "filled" or "bordered"
              icon: # Choose from 266 icons in "Feather" icon set, list of all icons is available here - https://feathericons.com
            - label: Button — Bordered
              url: /documentation
              external_url: false
              style: bordered
              icon:
---
