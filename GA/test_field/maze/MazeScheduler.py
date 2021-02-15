def get_column_info():
    traces = []
    with open('ScanResult.txt', 'r') as f:
        lines = f.readlines()
        for line in lines:
            kv_list = line.split('\t')
            trace_dict = {}
            for kv in kv_list:
                k_and_v = kv.split(':')
                if k_and_v[1].startswith('-'):
                    k_and_v[1] = k_and_v[1][1:]
                trace_dict[k_and_v[0]] = int(k_and_v[1])
            traces.append(trace_dict)
    blocklist = traces_to_blocklist(traces)
    return blocklist


def traces_to_blocklist(traces):
    blockdict = {}
    blocklist = []
    for trace in traces:
        x = trace['x_seg']
        ys = trace['y_seg_start']
        ye = trace['y_seg_end']
        if x not in blockdict:
            blockdict[x] = []
        blockdict[x].append(ys)
        blockdict[x].append(ye)
    for key in blockdict:
        blockdict[key] = list(set(blockdict[key]))
        blockdict[key].sort()
        temp_block = []
        for i, plane in enumerate(blockdict[key]):
            if i % 2 == 0:
                temp_block.clear()
                temp_block.append(plane)
            else:
                temp_block.append(plane)
                for j in range(temp_block[0], temp_block[1]):
                    blocklist.append((key, j))
    return blocklist


if __name__ == '__main__':
    get_column_info()
