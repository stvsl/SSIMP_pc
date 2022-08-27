function read(file) {
    var request = new XMLHttpRequest()
    request.open("GET", file, false) // false为同步操作设置
    request.send(null)
    return request.responseText
}

function write(file, text) {
    var request = new XMLHttpRequest()
    request.open("PUT", file, false) // false为同步操作设置
    request.send(text)
    return request.status
}
