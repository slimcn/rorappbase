// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$j = jQuery.noConflict(); // $j代替jQuery的$,防止jQuery与Prototype共用的冲突

$j(document).ready(function(){
    var responseData;

    $j('.expanded').addClass('collapsed');
    $j('.expanded').removeClass('expanded');

    $j('#div-nav-v li').click(function() {
        // 设置选中状态
        $j('.selected').removeClass('selected');
        $j(this).children('a').addClass('selected');
        // 设置子节点是否展开
        var tmpid = this.id;
        $j('#ul'+tmpid).attr('class',($j('#ul'+tmpid).attr('class'))=='expanded'?'collapsed':'expanded');
        // todo:若为叶子节点，则设置标题
        if ($j(this).attr('class') == 'child') {
            $j('head > title').attr('text',$j('.div-nav-subs > div > h2').attr('text'));
        }

        return false;
    });

<!-- // start // operate button action -->
    $j("button").click(function(){
        var btn_type = $j(this).attr("id");
        var pre_url = $j(this).attr("pre_url");
        //TODO: 若按钮类不属 jqgrid_form 调用普通界面  若属jqgrid_form，调用jqgrid默认界面
        if ($j(this).hasClass("jqgrid_form")) {
            if (btn_type=="btn_add") {
                $j("#add_tableRecs").click();
            } else if (btn_type=="btn_search") {
                $j("#tableRecs")[0].toggleToolbar();
                    //$j("#search_tableRecs").click();
            } else if (btn_type=="btn_refresh") {
                $j("#refresh_tableRecs").click();
            } else { // need id when operate
                $j("#tableRecs_select_button").click(); // 设置记录id
                if (var_id > 0) {
                    if (btn_type=="btn_update") {
                        $j("#edit_tableRecs").click();
                    } else if (btn_type=="btn_delete") {
                        $j("#del_tableRecs").click();
                    } else if (btn_type=="btn_show") {
                        $j("#show_tableRecs").click();
                    } else {
                        alert("未知操作请求！");
                    }
                } else {
                    alert("未知操作请求！");
                }
            }
        } else if ($j(this).hasClass("multi_model")) {
            if (btn_type=="btn_add") {
                openwin(pre_url+'/new');
            } else if (btn_type=="btn_search") {
                $j("#tableRecs")[0].toggleToolbar();
            } else if (btn_type=="btn_refresh") {
                $j("#refresh_tableRecs").click();
            } else { // need id when operate
                $j("#tableRecs_select_button").click(); // 设置记录id
                if (var_id > 0) {
                    if (btn_type=="btn_update") {
                        openwin(pre_url+'/'+var_id+'/edit')
                    } else if (btn_type=="btn_delete") {
                        $j("#del_tableRecs").click();
                    } else if (btn_type=="btn_show") {
                        openwin(pre_url+'/'+var_id)
                    } else if (btn_type=="btn_audit_self") {
                        openwin(pre_url+'/'+var_id+'/audit_self')
                    } else {
                        alert("未知操作请求！");
                    }
                } else {
                    alert("未知操作请求！");
                }
            }

        }
    });
<!-- // end // operate button action -->


    function openwin(url){
        window.open(url,'_self');
    }
});


function ExpandMenu(emcode, parentcode){
    var objParent = document.getElementById(parentcode);
    objParent.className = (objParent.className.toLowerCase() == "expanded"?"expanded":"expanded");
    var obj = document.getElementById(emcode);
    obj.className = (obj.className.toLowerCase() == "expanded"?"expanded":"expanded");
}

