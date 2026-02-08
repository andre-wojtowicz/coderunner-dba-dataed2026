FROM mcr.microsoft.com/mssql/server:2019-CU30-ubuntu-20.04
ADD nodirect_open.c /
USER root
RUN apt-get update \
	&& apt-get install -y gcc \
	&& gcc -shared -fpic -o /nodirect_open.so nodirect_open.c -ldl \
	&& apt-get purge -y gcc binutils binutils-common binutils-x86-64-linux-gnu cpp cpp-7 gcc gcc-7 \
  		gcc-7-base libasan4 libatomic1 libbinutils libc-dev-bin libc6-dev \
  		libcilkrts5 libgcc-7-dev libgomp1 libitm1 liblsan0 libmpc3 libmpx2 \
  		libquadmath0 libtsan0 libubsan0 linux-libc-dev manpages manpages-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& echo "/nodirect_open.so" >> /etc/ld.so.preload
