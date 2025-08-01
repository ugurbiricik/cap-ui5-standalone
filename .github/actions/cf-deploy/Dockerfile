FROM ppiper/cf-cli:v12

# needed for cf to find its config
# (GH resets HOME to /github/workspace)
ENV CF_HOME=$HOME

COPY --chmod=+x entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
