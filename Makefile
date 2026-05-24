OUT_DIR=output
IN_DIR=markdown
STYLES_DIR=styles
STYLE=chmduquesne
SCHEMES_DIR=schemes
SCHEME ?= forest

all: html pdf docx rtf

pdf: init
	. $(SCHEMES_DIR)/$(SCHEME).scheme; \
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone --template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			--variable papersize=A4 \
			--variable titlecolor=$$TITLE \
			--variable sectioncolor=$$SECTION \
			--variable rulecolor=$$RULE \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		(cd $(OUT_DIR) && context $$FILE_NAME.tex > context_$$FILE_NAME.log 2>&1); \
	done

html: init
	. $(SCHEMES_DIR)/$(SCHEME).scheme; \
	printf '<style>:root{--title-color:#%s;--section-color:#%s;--rule-color:#%s;--hr-color:#%s;}</style>\n' \
		"$$TITLE" "$$SECTION" "$$RULE" "$$HR" > $(OUT_DIR)/_scheme.css; \
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.html; \
		pandoc --standalone \
			--include-in-header $(STYLES_DIR)/$(STYLE).css \
			--include-in-header $(OUT_DIR)/_scheme.css \
			--lua-filter=pdc-links-target-blank.lua \
			--from markdown --to html \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f; \
	done

docx: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.docx; \
		pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.docx; \
	done

rtf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.rtf; \
		pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.rtf; \
	done

init: dir version

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

clean:
	rm -f $(OUT_DIR)/*
