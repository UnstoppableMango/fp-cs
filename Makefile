NIX ?= nix

build: result

.PHONY: result
result: src/UnMango.Fp/nix-deps.json
	$(NIX) build

src/UnMango.Fp/nix-deps.json: bin/fetch-deps.sh
	$< $@
bin/fetch-deps.sh: flake.nix src/UnMango.Fp/UnMango.Fp.csproj
	$(NIX) build .#fp-cs.fetch-deps --out-link $@
