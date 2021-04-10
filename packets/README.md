# Packets

## Generic

If a MySQL client or server wants to send data, it:

- Splits the data into packets of size (224−1) bytes
- Prepends to each chunk a packet header

Data between client and server is exchanged in packets of max 16MByte size. 

| Type        | Name           | Description                                                                                                         |
|-------------|----------------|---------------------------------------------------------------------------------------------------------------------|
| int<3>      | payload_length | Length of the payload. The number of bytes in the packet beyond the initial 4 bytes that make up the packet header. |
| int<1>      | sequence_id    | Sequence ID                                                                                                         |
| string<var> | payload        | [len=payload_length] payload of the packet                                                                          |

## OK

## Err

## EOF

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