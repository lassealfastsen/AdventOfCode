def hex_to_bin(hex_rep):
    return ''.join([f'{bin(int(c, 16))[2:]}'.rjust(4, '0') for c in hex_rep])


class Packet:

    def __init__(self, start_bit=0):
        self.start_bit = start_bit
        self.bits = ''
        self.version = None
        self.packet_type = None
        self.sub_packets = list()

        self.literal_value = 0
        self.padding = None

    def __len__(self):
        return len(self.bits)

    @property
    def version_sum(self):
        vs = int(self.version, 2)
        for sub_packet in self.sub_packets:
            vs += sub_packet.version_sum

        return vs

    @property
    def value(self):
        packet_type = int(self.packet_type, 2)

        if packet_type == 0:
            """
            Packets with type ID 0 are sum packets - 
            their value is the sum of the values of their sub-packets. 
            If they only have a single sub-packet, their value is the value of the sub-packet.
            """
            return sum(sub.value for sub in self.sub_packets)

        if packet_type == 1:
            """
            Packets with type ID 1 are product packets - 
            their value is the result of multiplying together the values of their sub-packets.
             If they only have a single sub-packet, their value is the value of the sub-packet.
            """
            v = 1
            for s in self.sub_packets:
                v *= s.value
            return v

        if packet_type == 2:
            """
            Packets with type ID 2 are minimum packets - 
            their value is the minimum of the values of their sub-packets.
            """
            return min(sub.value for sub in self.sub_packets)

        if packet_type == 3:
            """
            Packets with type ID 3 are maximum packets - 
            their value is the maximum of the values of their sub-packets.
            """
            return max(sub.value for sub in self.sub_packets)

        if packet_type == 4:
            """
            Literal values (type ID 4) represent a single number as described above. 
            """
            return self.literal_value

        if packet_type == 5:
            """
            Packets with type ID 5 are greater than packets - 
            their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; 
            otherwise, their value is 0. These packets always have exactly two sub-packets.
            """
            return 1 if self.sub_packets[0].value > self.sub_packets[1].value else 0

        if packet_type == 6:
            """
            Packets with type ID 6 are less than packets - 
            their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; 
            otherwise, their value is 0. These packets always have exactly two sub-packets.
            """
            return 1 if self.sub_packets[0].value < self.sub_packets[1].value else 0

        if packet_type == 7:
            """
            Packets with type ID 7 are equal to packets -
             their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; 
             otherwise, their value is 0. These packets always have exactly two sub-packets.
            """
            return 1 if self.sub_packets[0].value == self.sub_packets[1].value else 0

        else:
            raise NotImplementedError("Packet type:", packet_type)


def extract_from_hex(h):
    b = hex_to_bin(h)
    return extract_from_bin(b)


def extract_from_bin(b):
    pointer = 0
    # Find the header
    while pointer < len(b):
        pv = b[pointer:pointer+3]
        pt = b[pointer+3:pointer+6]

        # Instantiate a Packet
        packet = Packet(pointer)
        packet.version = pv
        packet.packet_type = pt
        pointer += 6

        # If it's a literal, our values are already here
        if pt == '100':  # id: 4
            group_val = ''
            while True:
                group = b[pointer:pointer + 5]
                pointer += 5
                group_val += group[1:]
                if group[0] == '0':
                    packet.bits = b[packet.start_bit:pointer]
                    packet.literal_value = int(group_val, 2)
                    return packet

        # Otherwise, create sub-packets (recursion FTW!)
        else:
            length_type_id = int(b[pointer], 2)
            pointer += 1
            if length_type_id == 0:  # length reps number of bits
                sub_pack_length = int(b[pointer:pointer+15], 2)
                pointer += 15
                sub_packets = list()
                pointer_2 = 0
                while pointer_2 < sub_pack_length:
                    sub_bin = b[pointer+pointer_2:]
                    sub_pack = extract_from_bin(sub_bin)
                    sub_packets.append(sub_pack)
                    pointer_2 += len(sub_pack)
                packet.sub_packets = sub_packets
                pointer += pointer_2

            if length_type_id == 1:  # length reps number of packets
                sub_pack_count = int(b[pointer:pointer+11], 2)
                pointer += 11
                sub_packets = list()

                while len(sub_packets) < sub_pack_count:
                    sub_bin = b[pointer:]
                    sub_pack = extract_from_bin(sub_bin)
                    sub_packets.append(sub_pack)
                    pointer += len(sub_pack)
                packet.sub_packets = sub_packets

        packet.bits = b[packet.start_bit:pointer]

        return packet


def tests():

    # Hex to binary conversion tests
    conversion_tests = [('D2FE28',          '110100101111111000101000'),
                        ('38006F45291200',  '00111000000000000110111101000101001010010001001000000000'),
                        ('EE00D40C823060',  '11101110000000001101010000001100100000100011000001100000')]
    for h, b in conversion_tests:
        test_result = hex_to_bin(h)
        assert test_result == b, test_result

    packet = extract_from_hex('D2FE28')
    assert packet.value == 2021

    # From binary tests
    single_tests = [
        ('11010001010',         10),
        ('0101001000100100',    20),
        ('01010000001',          1),
        ('10010000010',          2),
        ('00110000011',          3)]
    for i, r in single_tests:
        packet = extract_from_bin(i)
        assert packet.value == r, i

    # Version sum tests
    version_sum_tests = [
        ('8A004A801A8002F478',              16),
        ('620080001611562C8802118E34',      12),
        ('C0015000016115A2E0802F182340',    23),
        ('A0016C880162017C3686B18A3D4780',  31)]
    for h, r in version_sum_tests:
        packet = extract_from_hex(h)
        pv = packet.version_sum
        assert packet.version_sum == r, pv

    # Value tests
    test_cases = [
        ('C200B40A82',                 3),
        ('04005AC33890',              54),
        ('880086C3E88112',             7),
        ('CE00C43D881120',             9),
        ('D8005AC2A8F0',               1),
        ('F600BC2D8F',                 0),
        ('9C005AC2F8F0',               0),
        ('9C0141080250320F1802104A08', 1),
    ]
    for i, r in test_cases:
        packet = extract_from_hex(i)
        test_result = packet.value
        assert test_result == r, i


def main():
    with open('./input.txt') as f:
        data = f.read().splitlines()

    packet = extract_from_hex(data[0])
    print(packet.version_sum)
    print(packet.value)


if __name__ == '__main__':

    tests()
    main()
