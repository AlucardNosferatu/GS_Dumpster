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
    blocklist = {}
    for trace in traces:
        x = trace['x_seg']
        ys = trace['y_seg_start']
        ye = trace['y_seg_end']
        if x not in blocklist:
            blocklist[x]=[]
        blocklist[x].append(ys)
        blocklist[x].append(ye)
    for key in blocklist:
        blocklist[key]=list(set(blocklist[key]))
    return blocklist


if __name__ == '__main__':
    get_column_info()
