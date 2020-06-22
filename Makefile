SOURCE="https://github.com/sindresorhus/caprine/releases/download/v2.47.0/Caprine-2.47.0.AppImage"
OUTPUT="Caprine.AppImage"

all:
	echo "Building: $(OUTPUT)"
	rm -f ./$(OUTPUT)
	wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" --output-document=$(OUTPUT) --continue $(SOURCE)
	chmod +x $(OUTPUT)

