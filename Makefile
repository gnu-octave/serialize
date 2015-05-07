OCTAVE    ?= octave

.PHONY: check

check:
	$(OCTAVE) --no-window-system --silent --eval 'runtests (".");'
