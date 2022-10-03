bash -c "curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash && \
cd NoitaMP && \
sudo service docker start && \
act -l && \

sudo ./bin/act -v -s WORKFLOW_PAT=$(pass tokens/github) pull_request_target
"

## pass insert tokens/github


https://stackoverflow.com/a/67360592/3493998

