DASM=/Users/cprieto/Code/dasm/bin/dasm
INCLUDE=/Users/cprieto/Code/dasm/machines/atari2600
ARGS=-f3 -v4

% : %.s
	$(DASM) $< -o$@.bin -I$(INCLUDE) -l$@.lst $(ARGS)

clean:
	rm -rf *.bin *.txt
