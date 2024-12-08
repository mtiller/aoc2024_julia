all:
	jlrun Runlit/run -i ./src -o ./output

watch:
	jlrun Runlit/watch -i ./src -o ./output