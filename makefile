slides-pandoc:
	pandoc -t html5 --template=template-revealjs.html --standalone --section-divs --variable transition="linear" --variable theme="black" --variable highlight-style="gruvbox-dark" slides.md -o slides.html
