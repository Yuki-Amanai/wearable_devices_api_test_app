.PHONY: setup
get:
	fvm flutter clean
	fvm flutter pub get

.PHONY: list
list:
	fvm list

.PHONY: d
d:
	fvm flutter devices

# 会社携帯
.PHONY: run1
run1:
	fvm flutter run --debug -d b06883e653f4b7f41c2e1b12de9d61356668e8ef

# 自分用携帯
.PHONY: run2
run2:
	fvm flutter run --debug -d 00008030-000409AC2144802E






