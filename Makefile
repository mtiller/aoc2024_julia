all:
	jlrun Runlit/run -p . -i ./src -o ./output

watch:
	jlrun Runlit/watch -p . -i ./src -o ./output