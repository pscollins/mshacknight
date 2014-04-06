from sys import argv

DEFAULT_BTN_PROPERTIES = {
    'class': "btn btn-primary btn-lg leap-interactive",
    'role': "button",
    'leap-click-delay': '100',
    'leap-enable-multitap': 'true',
}

ONCLICK_FMT = "soundManager.play('s{}')"

BTN_NAME_FMT = "## <br> <br> {}"

WRAP_FMT = '''<div class="col-{type_}-{size}">
<p>{body}</p>
</div>'''

def make_button(sound_num, **kwargs):
    FMT = "<a {kwargs}> {name} </a>"
    kwargs['onclick'] = ONCLICK_FMT.format(sound_num)
    tag_kwargs = ['{key}="{value}"'.format(key=key, value=value)
                  for key, value in kwargs.items()]
    return FMT.format(kwargs=" ".join(tag_kwargs),
                      name=BTN_NAME_FMT.format(sound_num))

def main(num=10):
    rows = "\n".join([WRAP_FMT.format(
        type_='xs',
        size='1',
        body=make_button(i, **DEFAULT_BTN_PROPERTIES))
        for i in range(10)])

    print(rows)


if __name__ == '__main__':
    main(argv[1])
