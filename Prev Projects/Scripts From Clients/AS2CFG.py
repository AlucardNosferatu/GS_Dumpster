

lines=[]
with open("UREnhanced.as", "r") as asp:  # 打开文件
    id=asp.name.replace('.as','')
    send_start = 'dick ' + '"upload_start ' + id + '"' + '\n'
    lines.append(send_start)
    for i in range(2):
        lines.append('wait\n')
    while True:
        code_sentence=asp.readline()
        if not code_sentence:
            break
        else:
            send_content = 'dick ' + '"upload_send_line ' + id + ' ' + code_sentence.replace('\n', '').replace('"', '$QUOTE$') + '"' + '\n'
            lines.append(send_content)
            for i in range(2):
                lines.append('wait\n')
    send_stop = 'dick ' + '"upload_stop ' + id + '"' + '\n'
    lines.append(send_stop)
with open("upload_asp.cfg", "w") as cfg:
    cfg.writelines(lines)