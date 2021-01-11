def GetCFG(input_file="UREnhanced.as", output_file="upload_asp.cfg"):
    lines = []
    with open(input_file, "r") as asp:  # 打开文件
        id = asp.name.replace('.as', '')
        send_start = 'dick ' + '"upload_start ' + id + '"' + '\n'
        lines.append(send_start)
        for i in range(2):
            lines.append('wait\n')
        while True:
            code_sentence = asp.readline()
            if not code_sentence:
                break
            else:
                code_sentence = code_sentence.replace('\n', '')
                code_sentence = code_sentence.replace('"', '$QUOTE$')
                send_content = 'dick '
                send_content += '"upload_send_line '
                send_content += (id + ' ')
                send_content += code_sentence
                send_content += ('"' + '\n')
                lines.append(send_content)
                for i in range(2):
                    lines.append('wait\n')
        send_stop = 'dick ' + '"upload_stop ' + id + '"' + '\n'
        lines.append(send_stop)
    with open(output_file, "w") as cfg:
        cfg.writelines(lines)
