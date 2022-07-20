FROM elixir:1.12 AS rabbitmq-server-5251

WORKDIR /rabbitmq

RUN apt update && apt install --yes --no-install-recommends rsync
RUN git clone --branch feature-delete-connection-by-name https://github.com/NuwanSameera/rabbitmq-server.git
RUN make -C rabbitmq-server && \
    make -C rabbitmq-server/deps/rabbit dist && \
    make -C rabbitmq-server/deps/rabbitmq_management dist

FROM rabbitmq:3.10.6-management

COPY --from=rabbitmq-server-5251 --chown=rabbitmq:rabbitmq /rabbitmq/rabbitmq-server/deps/rabbit/plugins/rabbit-*/ebin/rabbit_connection_tracking.beam /opt/rabbitmq/plugins/rabbit-3.10.6/ebin/
COPY --from=rabbitmq-server-5251 --chown=rabbitmq:rabbitmq /rabbitmq/rabbitmq-server/deps/rabbitmq_management/plugins/rabbitmq_management-*/ebin/rabbit_mgmt_dispatcher.beam /opt/rabbitmq/plugins/rabbitmq_management-3.10.6/ebin/
COPY --from=rabbitmq-server-5251 --chown=rabbitmq:rabbitmq /rabbitmq/rabbitmq-server/deps/rabbitmq_management/plugins/rabbitmq_management-*/ebin/rabbit_mgmt_wm_connection_user_name.beam /opt/rabbitmq/plugins/rabbitmq_management-3.10.6/ebin/
