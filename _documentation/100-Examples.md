---
# Page settings
title: EXAMPLES # Define a title of your page
description: Examples # Define a description of your page
keywords: # Define keywords for search engines
order: 100 # Define order of this page in list of all documentation documents
comments: true # Set to "true" in order to enable comments on this page. Make sure you properly setup "disqus_forum_shortname" variable in "_config.yml"

# Hero section
hero:
    title: Static IP — Title
    text: Static IP — Text
---

<div class="example"></div>


<div class="callout callout--info">
    <p><strong>This is info callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>


<div class="callout html">
    <p><strong>This is info callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>

<div markdown="span" class="alert alert-info" role="alert"><i class="fa fa-info-circle"></i> <b>Note:</b> {{include.content}}</div>


<div class="callout callout--info">
    <p><strong>This is info callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>

<div class="callout callout--warning">
    <p><strong>This is warning callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>

<div class="callout callout--danger">
    <p><strong>This is danger callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>

<div class="callout callout--success">
    <p><strong>This is success callout!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>

{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}

```bash
# Config of 

# array of URL for AdblockPlus lists
#  for more sources just add it within the round brackets
URLS=("https://easylist.to/easylist/easylist.txt" "https://easylist.to/easylist/easyprivacy.txt" "https://easylist.to/easylist/fanboy-annoyance.txt" "https://easylist.to/easylist/fanboy-social.txt")
```


```html
<div class="corp_presentation">

<h1>Aïkido Washinkai</h1>
<br />

<img src="media/presentation/ueshiba_morihei.jpg" id="ueshiba_pict1" alt="ueshiba_morihei" />

<div class="ueshiba_morihei">
```


<div class="example"></div>


<div class="callout">
    <p><strong>This is info callout!</strong>[https://help.github.com/articles/basic-writing-and-formatting-syntax/#quoting-code]</p>
</div>


[https://help.github.com/articles/basic-writing-and-formatting-syntax/#quoting-code](https://help.github.com/articles/basic-writing-and-formatting-syntax/#quoting-code)


# The largest heading
## The second largest heading
###### The smallest heading


**This is bold text**

*This text is italicized*

~~This was mistaken text~~

**This text is _extremely_ important**

> Pardon my French

Use `git status` to list all new or modified files that haven't yet been committed.

```
git status
git add
git commit
```

This site was built using [GitHub Pages](https://pages.github.com/).

[Contribution guidelines for this project](docs/CONTRIBUTING.md)

- George Washington
- John Adams
- Thomas Jefferson

1. James Madison
2. James Monroe
3. John Quincy Adams

1. First list item
   - First nested list item
     - Second nested list item

100. First list item
     - First nested list item

100. First list item
     - First nested list item
       - Second nested list item


- [x] Finish my changes
- [ ] Push my commits to GitHub
- [ ] Open a pull request

- [ ] \(Optional) Open a followup issue

@github/support What do you think about these updates?

@octocat :+1: This PR looks great - it's ready to merge! :shipit:

Let's rename \*our-new-project\* to \*our-old-project\*.

<s>this is strike through text</s>

