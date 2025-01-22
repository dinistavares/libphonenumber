WHOAMI=$(shell whoami)

SED_I = sed -i
ifeq ($(shell uname -s), Darwin)
    SED_I = sed -i ''
endif

nothing:

generate_proto:
	protoc -I. \
		-I./google_libphonenumber \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=Mgoogle_libphonenumber/resources/phonenumber.proto=github.com/dinistavares/libphonenumber/phonemetadata \
		--go_opt=Mgoogle_libphonenumber/resources/phonemetadata.proto=github.com/dinistavares/libphonenumber/phonemetadata \
		--go_opt=Mgoogle/protobuf/field_mask.proto=github.com/google/go-genproto/protobuf/field_mask \
		--go-grpc_opt=Mgoogle_libphonenumber/resources/phonenumber.proto=github.com/dinistavares/libphonenumber/phonemetadata \
		--go-grpc_opt=Mgoogle_libphonenumber/resources/phonemetadata.proto=github.com/dinistavares/libphonenumber/phonemetadata \
		--go-grpc_opt=Mgoogle/protobuf/field_mask.proto=github.com/google/go-genproto/protobuf/field_mask \
		./google_libphonenumber/resources/phonenumber.proto \
		./google_libphonenumber/resources/phonemetadata.proto
	find . -name "*.pb.go" -exec mv {} . \;
	sudo chown -R $(WHOAMI) *
	$(SED_I) -E 's/package i18n_phonenumbers/package libphonenumber/g' $(shell ls *.pb.go)
	awk '/static const unsigned char/ { show=1 } show; /}/ { show=0 }' ./google_libphonenumber/cpp/src/phonenumbers/metadata.cc | tail -n +2 | sed '$$d' | sed -E 's/([^,])$$/\1,/g' | awk 'BEGIN{print "package libphonenumber\nvar metaData = []byte{"}; {print}; END{print "}"}' > metagen.go
	go fmt ./metagen.go

distupdate:
	rm -rf ./google_libphonenumber
	git clone --depth 1 https://github.com/googlei18n/libphonenumber.git ./google_libphonenumber/

update: distupdate generate_proto
