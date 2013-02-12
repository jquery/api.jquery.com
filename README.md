## Referencing Bug Tracker Tickets

* Pull requests for changes that were requested or recommended via the [jQuery Bug Tracker](http://bugs.jquery.com) should include a link back to the relevant ticket.

## Building

### Requirements
* <a href="http://www.xmlsoft.org/">libxml2</a>
* <a href="http://xmlsoft.org/XSLT/">libxslt</a>

The `xmllint` and `xsltproc` utilities need to be in your path. If you are on Windows, you can get libxml2 and libxslt from <a href="http://www.zlatkovic.com/libxml.en.html">zlatkovic.com</a>.

### Build

To build and deploy your changes for previewing in a [jquery-wp-content](https://github.com/jquery/jquery-wp-content) instance, follow the [workflow instructions](http://contribute.jquery.org/web-sites/#workflow) from our documentation on [contributing to jQuery Foundation web sites](http://contribute.jquery.org/web-sites/).

## Style Guidelines

### Prose Style & Grammar

#### Sentence Structure

* Write in clear, easy-to-understand statements.
* Keep sentences short and to the point.
* Include the Oxford (serial) comma in a list of three or more items.
  * **Yes**: The `load`, `scroll`, and `error` events (e.g., on an `<img>` element) do not bubble
  * **No**: The `load`, `scroll` and `error` events (e.g., on an `<img>` element) do not bubble

#### Spelling
* The documentation standardizes on American English spelling. For example:
  * **Yes**: color, while, among, customize, argument
  * **No**: colour, whilst, amongst, customise, arguement

#### Pronoun Usage
* Use second-person pronoun ("you") when necessary, but try to avoid it.
* Favor the definite article ("the") over second-person possesive ("your").
  * **Yes**: Insert the paragraph after the unordered list.
  * **No**: Insert your paragraph after the unordered list.
* When editing current entries, change first-person plural pronouns ("we," "our," "us") to second-person.
  * **Yes**: The `.insertAfter()` method here adds an unordered list beneath the paragraph.
  * **No**: And now we have our paragraph beneath the unordered list.

#### "Voice"
* Prefer active voice over passive.
  * **Active**: Calling `.click()` binds a click handler to the elements in the collection
  * **Passive**: Click handlers are bound to elements in the collection when `.click()` is called

### Code Style
Code in the API documentation should follow the [jQuery Core Style Guide](http://docs.jquery.com/JQuery_Core_Style_Guidelines) with the following addition and exception:

* **Document ready syntax**: Use `$( document ).ready(function() {` instead of `$(function() {` as it's harder for new users to distinguish the difference between the latter and an IIFE.
* **Indentation**: Core guidelines say to use tabs. In API documentation, *use 2 spaces instead*. This helps keep the line width manageable and avoid horizontal scrollbars.

#### Code within prose content (paragraphs and the like):
* Methods: use a dot, followed by the method name, followed by parentheses: e.g. The `.focus()` method is a shortcut for `.bind('focus', handler)` in the first and second variations, and `.trigger('focus')` in the third.
* Properties: use a dot, followed by the property name: e.g. `.length`.
* Functions: use the function name, followed by parentheses: `myFunction()`.

#### Examples
* Examples should indicate what the expected result will be before presenting the code. This makes code clearer and skimming easier, especially for newer coders who may not understand what is supposed to be happening from reading the code itself.
  * **Yes**: Find all p elements that are children of a div element and apply a border to them.
  * **No**: Find all p elements that are children of a div element.
* Make your example easy to follow with good comments so that the explanation isn't necessary.

### Rhetorical Context
* Subject
  * The entirety of jQuery's public API
* Audience
  * jQuery users
  * International: Native and non-native English readers
  * Experience Level: Absolute beginner through expert
  * First-time through frequent consumers of site
* Purpose
  * Describe comprehensively and accessibly every public method, property, and selector in the jQuery library
  * Reinforce understanding of concepts through relevant code examples
  * Demonstrate the effect the methods have by executing code examples
* Authors
  * Proficient in JavaScript development
  * Well versed in jQuery best practices
  * Strong in English writing
* Tone
  * Middle ground between formal and familiar. Err on the side of formality.
  * Authoritive
  * Tactful
