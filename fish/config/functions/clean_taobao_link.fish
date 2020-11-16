
function clean_taobao_link -d 'keep only id parameter for taobao merchandise detail page link'
    xsel -ob | sed 's/^\(.*\)?\(.*&\)\?\(id=[^&]\+\).*$/\1?\3/g' | xsel -b
end
