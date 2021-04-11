# Packets

## Generic

If a MySQL client or server wants to send data, it:

- Splits the data into packets of size (224−1) bytes
- Prepends to each chunk a packet header

Data between client and server is exchanged in packets of max 16MByte size. 

| Type        | Name           | Description                                                                           |
|-------------|----------------|---------------------------------------------------------------------------------------|
| int<3>      | payload_length | Payload length. The number of bytes in the packet beyond this initial 4 bytes header. |
| int<1>      | sequence_id    | Sequence ID                                                                           |
| string<var> | payload        | [len=payload_length] payload of the packet                                            |

## OK

## Err

## EOF

| Type                                 | Name         | Description        |
|--------------------------------------|--------------|--------------------|
| int<1>                               | header       | [fe] EOF header    |
| if capabilities & CLIENT_PROTOCOL_41 |              |                    |
| int<2>                               | warnings     | number of warnings |
| int<2>                               | status_flags | Status flags       |

> In the MySQL client/server protocol, EOF and OK packets serve the same purpose, to mark the end of a query execution result. The EOF packet is deprecated in MySQL 5.7.5.

## Execute Statement

| Type                          | Name                                           |
|-------------------------------|------------------------------------------------|
| int<1>                        | [17] COM_STMT_EXECUTE                          |
| int<4>                        | stmt_id                                        |
| int<1>                        | flags                                          |
| int<4>                        | iteration_count                                |
| if num_params > 0             |                                                |
| n                             | NULL-bitmap, length: (num_params+7)/8          |
| int<1>                        | new_params_bound_flag                          |
| if new_params_bound_flag == 1 |                                                |
| n                             | type of each parameter, length: num_params * 2 |
| n                             | value of each parameter                        |

> The `iteration_count` is always `1`.

The `flags` are:

| Flag | Name                   |
|------|------------------------|
| 0x00 | CURSOR_TYPE_NO_CURSOR  |
| 0x01 | CURSOR_TYPE_READ_ONLY  |
| 0x02 | CURSOR_TYPE_FOR_UPDATE |
| 0x04 | CURSOR_TYPE_SCROLLABLE |