FROM ubuntu:latest
RUN apt -y update && apt -y upgrade
RUN apt -y install perl git wget xz-utils gcc less vim nano
# for the wolfram-engine rpm itself
#RUN systemctl enable avahi-daemon
COPY /WolframEngine_14.3.0_LIN.sh /Wolfram
RUN chmod u+x /Wolfram
RUN ls -la /Wolfram
RUN /bin/sh /Wolfram
#RUN echo "marco.pedicini@uniroma3.it\ncantor1848$R\n" | /bin/sh /usr/local/bin/wolframscript
RUN ["bash"]
