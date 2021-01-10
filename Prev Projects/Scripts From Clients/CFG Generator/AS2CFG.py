

lines=[]
with open("UREnhanced.as", "r") as asp:  # 打开文件
    id=asp.name.replace('.as','')
    send_start = 'dick ' + '"upload_start ' + id + '"' + '\n'
    # send_start = 'say ' + '"' + id + '"' + '\n'
    lines.append(send_start)
    for i in range(16):
        lines.append('wait\n')
    while True:
        code_sentence=asp.readline()
        if not code_sentence:
            break
        else:
            send_content = 'dick ' + '"upload_send_line ' + id + ' ' + code_sentence.replace('\n', '').replace('"', '$QUOTE$') + '"' + '\n'
            # send_content = 'say ' + '"' + code_sentence.replace('\n', '').replace('"', '$QUOTE$') + '"' + '\n'
            lines.append(send_content)
            for i in range(16):
                lines.append('wait\n')
    # send_end = 'asp_upload_end ' + '"' + id + '"'
    send_end = 'dick ' + '"upload_stop ' + id + '"'
    lines.append(send_end)
with open("upload_asp.cfg", "w") as cfg:
    cfg.writelines(lines)