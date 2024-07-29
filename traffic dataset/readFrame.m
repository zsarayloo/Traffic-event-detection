function frame = readFrame()
        global obj
        frame = obj.reader.step();
    end