<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template name="note">
	<xsl:choose>
		<xsl:when test="@id = 'data-doesnt-accept-undefined'">
			<code>undefined</code> is not recognized as a data value. Calls such as <code><xsl:value-of select="@data-title" />( <xsl:value-of select="@data-parameters" />, undefined )</code> will return the jQuery object that it was called on, allowing for chaining.
		</xsl:when>
		<xsl:when test="@id = 'jquery-data-doesnt-accept-undefined'">
			<code>undefined</code> is not recognized as a data value. Calls such as <code><xsl:value-of select="@data-title" />( <xsl:value-of select="@data-parameters" />, undefined )</code> will return the corresponding data for "name", and is therefore the same as <code><xsl:value-of select="@data-title" />( <xsl:value-of select="@data-parameters" /> )</code>.
		</xsl:when>
		<xsl:when test="@id = 'dimensions-number'">
			The number returned by dimensions-related APIs, including <code><xsl:value-of select="@data-title"/></code>, may be fractional in some cases. Code should not assume it is an integer. Also, dimensions may be incorrect when the page is zoomed by the user; browsers do not expose an API to detect this condition.
		</xsl:when>
		<xsl:when test="@id = 'disconnected-manipulation'">
			Prior to jQuery 1.9, <code><xsl:value-of select="@data-title"/></code> would attempt to add or change nodes in the current jQuery set if the first node in the set was not connected to a document, and in those cases return a new jQuery set rather than the original set. The method might or might not have returned a new result depending on the number or connectedness of its arguments! As of jQuery 1.9, <code>.after()</code>, <code>.before()</code>, and <code>.replaceWith()</code> always return the original unmodified set. Attempting to use these methods on a node without a parent has no effect—that is, neither the set nor the nodes it contains are changed.
		</xsl:when>
		<xsl:when test="@id = 'document-order'">
			Selected elements are in the order of their appearance in the document.
		</xsl:when>
		<xsl:when test="@id = 'domlint'">
			Forms and their child elements should not use input names or ids that conflict with properties of a form, such as <code>submit</code>, <code>length</code>, or <code>method</code>. Name conflicts can cause confusing failures. For a complete list of rules and to check your markup for these problems, see <a href="http://kangax.github.com/domlint/">DOMLint</a>.
		</xsl:when>
		<xsl:when test="@id = 'inaccurate-dimensions-for-hidden-elements'">
			The value reported by <code><xsl:value-of select="@data-title" /></code> is not guaranteed to be accurate when the element's parent is hidden. To get an accurate value, you should show the parent first, before using <code><xsl:value-of select="@data-title" /></code>.
		</xsl:when>
		<xsl:when test="@id = 'jquery-selector-extension'">
			Because <code><xsl:value-of select="@data-selector"/></code> is a jQuery extension and not part of the CSS specification, queries using <code><xsl:value-of select="@data-selector"/></code> cannot take advantage of the performance boost provided by the native DOM <code>querySelectorAll()</code> method. To achieve the best performance when using <code><xsl:value-of select="@data-selector"/></code> to select elements, first select the elements using a pure CSS selector, then use <a href="/filter/"><code>.filter("<xsl:value-of select="@data-selector"/>")</code></a>.
		</xsl:when>
		<xsl:when test="@id = 'jquery-selector-extension-alt'">
			Because <code><xsl:value-of select="@data-selector"/></code> is a jQuery extension and not part of the CSS specification, queries using <code><xsl:value-of select="@data-selector"/></code> cannot take advantage of the performance boost provided by the native DOM <code>querySelectorAll()</code> method. For better performance in modern browsers, use <code><xsl:value-of select="@data-alt"/></code> instead.
		</xsl:when>
		<xsl:when test="@id = 'jquery.fx.off'">
			All jQuery effects, including <code><xsl:value-of select="@data-title"/></code>, can be turned off globally by setting <code>jQuery.fx.off = true</code>, which effectively sets the duration to 0. For more information, see <a href="/jquery.fx.off/">jQuery.fx.off</a>.
		</xsl:when>
		<xsl:when test="@id = 'no-data-on-xml'">
			Note that this method currently does not provide cross-platform support for setting data on XML documents, as Internet Explorer does not allow data to be attached via expando properties.
		</xsl:when>
		<xsl:when test="@id = 'prop-memory-leaks'">
			In Internet Explorer prior to version 9, using <code><a href="/prop/">.prop()</a></code> to set a DOM element property to anything other than a simple primitive value (number, string, or boolean) can cause memory leaks if the property is not removed (using <a href="/removeProp/"><code>.removeProp()</code></a>) before the DOM element is removed from the document. To safely set values on DOM objects without memory leaks, use <a href="/data/"><code>.data()</code></a>.
		</xsl:when>
		<xsl:when test="@id = 'propagation-for-live-or-delegate'">
			Since the <a href="/live/"><code>.live()</code></a> method handles events once they have propagated to the top of the document, it is not possible to stop propagation of live events. Similarly, events handled by <code><a href="/delegate/">.delegate()</a></code> will propagate to the elements to which they are delegated; event handlers bound on any elements below it in the DOM tree will already have been executed by the time the delegated event handler is called. These handlers, therefore, may prevent the delegated handler from triggering by calling <code><a href="/event.stopPropagation/">event.stopPropagation()</a></code> or returning <code>false</code>.
		</xsl:when>
		<xsl:when test="@id = 'removes-data'">
			The <code><xsl:value-of select="@data-title"/></code> method removes all data and event handlers associated with the removed nodes.
		</xsl:when>
		<xsl:when test="@id = 'same-origin-policy'">
			Due to browser security restrictions, most "Ajax" requests are subject to the <a title="Same Origin Policy on Wikipedia" href="http://en.wikipedia.org/wiki/Same_origin_policy">same origin policy</a>; the request can not successfully retrieve data from a different domain, subdomain, port, or protocol.
		</xsl:when>
		<xsl:when test="@id = 'same-origin-policy-exceptions'">
			Script and JSONP requests are not subject to the same origin policy restrictions.
		</xsl:when>
		<xsl:when test="@id = 'use-ajaxerror'">
			If a request with <xsl:value-of select="@data-title"/> returns an error code, it will fail silently unless the script has also called the global <a href="/ajaxError/">.ajaxError() </a> method. Alternatively, as of jQuery 1.5, the <code>.error()</code> method of the <code>jqXHR</code> object returned by <xsl:value-of select="@data-title"/> is also available for error handling.
		</xsl:when>
		<xsl:when test="@id = 'ajax-global-false'">
			If <code><a href="/jQuery.Ajax/">$.ajax()</a></code> or <code><a href="/jQuery.ajaxSetup/">$.ajaxSetup()</a></code> is called with the <code>global</code> option set to <code>false</code>, the <code><xsl:value-of select="@data-title"/></code> method will not fire.
		</xsl:when>
		<xsl:when test="@id = 'slide-in-ie'">
			If <code><xsl:value-of select="@data-title"/></code> is called on an unordered list (<code>&lt;ul&gt;</code>) and its <code>&lt;li&gt;</code> elements have position (relative, absolute, or fixed), the effect may not work properly in IE6 through at least IE9 unless the <code>&lt;ul&gt;</code> has "layout." To remedy the problem, add the <code>position: relative;</code> and <code>zoom: 1;</code> CSS declarations to the <code>ul</code>.
		</xsl:when>
		<xsl:when test="@id = 'html-code-execution'">
			By design, any jQuery constructor or method that accepts an HTML string — <a href="/jQuery/">jQuery()</a>, <a href="/append/">.append()</a>, <a href="/after/">.after()</a>, etc. — can potentially execute code. This can occur by injection of script tags or use of HTML attributes that execute code (for example, <code>&lt;img onload=""&gt;</code>). Do not use these methods to insert strings obtained from untrusted sources such as URL query parameters, cookies, or form inputs. Doing so can introduce cross-site-scripting (XSS) vulnerabilities. Remove or escape any user input before adding content to the document.
		</xsl:when>
		<xsl:when test="@id = 'hidden-forces-layout'">
			Using this selector heavily can have performance implications, as it may force the browser to re-render the page before it can determine visibility. Tracking the visibility of elements via other methods, using a class for example, can provide better performance.
		</xsl:when>
		<xsl:when test="@id = 'detach-shorthand'">
			As the <code>.<xsl:value-of select="@data-event"/>()</code> method is just a shorthand for <code>.on( "<xsl:value-of select="@data-event"/>", handler )</code>, detaching is possible using <code>.off( "<xsl:value-of select="@data-event"/>" )</code>.
		</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
