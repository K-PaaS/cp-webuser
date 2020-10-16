<%--
  Roles List View
  @author kjhoon
  @version 1.0
  @since 2020.10.13
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<div class="sortable_wrap">
    <div class="sortable_top">
        <p>Roles</p>
        <ul class="colright_btn">
            <li>
<%--                <input type="text" id="table-search-01" name="" class="table-search" placeholder="search"--%>
<%--                       onkeypress="if(event.keyCode===13) {setRolesList(this.value);}" maxlength="100"/>--%>
<%--                <button name="button" class="btn table-search-on" type="button">--%>
<%--                    <i class="fas fa-search"></i>--%>
<%--                </button>--%>
            </li>
        </ul>
    </div>
    <div class="view_table_wrap">
        <table class="table_event condition alignL" id="resultRolesTable">
            <colgroup>
                <col style="width:auto;">
                <col style="width:25%;">
                <col style="width:25%;">
                <col style="width:25%;">
            </colgroup>
            <thead>
            <tr id="noResultRolesArea" style="display: none;">
                <td colspan='4'><p class='service_p'>실행 중인 Role이 없습니다.</p></td>
            </tr>
            <tr id="resultRolesHeaderArea" class="headerSortFalse">
                <td>Name
                    <button class="sort-arrow" onclick="procSetSortList('resultRolesTable', this, '0')"><i
                            class="fas fa-caret-down"></i></button>
                </td>
                <td>Labels</td>
                <td>Annotations</td>
                <td>Created on
                    <button class="sort-arrow" onclick="procSetSortList('resultRolesTable', this, '3')"><i
                            class="fas fa-caret-down"></i></button>
                </td>
            </tr>
            </thead>
            <tbody id="rolesListArea"></tbody>
        </table>
    </div>
    <div><button id="rolesMoreDetailBtn" class="resourceMoreDetailBtn">더보기(More)</button></div>
</div>


<script type="text/javascript">

    var G_ROLES_LIST;
    var G_ROLES_LIST_LENGTH;
    var G_DEV_CAHRT_RUNNING_CNT = 0;
    var G_DEV_CHART_FAILED_CNT = 0;
    var G_DEV_CHART_SUCCEEDEDCNT = 0;
    var G_DEV_CHART_PENDDING_CNT = 0;
    
    var G_ROLES_LIST_CONTINUE_TOKEN = "";
    var G_ROLES_LIST_GET_FIRST = true;
    
    
    
    var getRolesList = function (limit, continue_token) {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_ROLES_LIST %>" + "?limit=" + limit;

        if (continue_token.length > 1) {
            reqUrl = reqUrl + "&continue=" + continue_token;
        }
        var reqUrl = reqUrl.replace("{namespace:.+}", NAME_SPACE);

        procCallAjax(reqUrl, "GET", null, null, callbackgetRolesList);

    };

    // CALLBACK
    var callbackgetRolesList = function (data) {
        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage();
            return false;
        }


        G_ROLES_LIST = data;
        G_ROLES_LIST_LENGTH = data.items.length;


        if(data.metadata.hasOwnProperty('continue')){
            G_ROLES_LIST_CONTINUE_TOKEN = data.metadata.continue;
        }

        if(!data.metadata.hasOwnProperty('remainingItemCount')){
            $('#rolesMoreDetailBtn').css("display", "none");
        }

        setRolesList("");

    };

    var setRolesList = function (searchKeyword) {
        procViewLoading('show');

        var resultArea = $('#rolesListArea');
        var resultHeaderArea = $('#resultRolesHeaderArea');
        var noResultArea = $('#noResultRolesArea');
        var resultTable = $('#resultRolesTable');

        var checkListCount = 0;
        var htmlString = [];

        $.each(G_ROLES_LIST.items, function (index, itemList) {
            var metadata = itemList.metadata;
            var rules = itemList.rules;
            var roleName = metadata.name;

            if ((nvl(searchKeyword) === "") || roleName.indexOf(searchKeyword) > -1) {
                var namespace = metadata.namespace;

                // 라벨이 없는 경우도 있음.
                var labels = procSetSelector(metadata.labels);
                var annotations = procSetAnnotations(metadata.annotations);
                var creationTimestamp = metadata.creationTimestamp;

                htmlString.push('<tr>' +
                    '<td>' + "<a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.URI_ROLES %>/" + roleName + "\");'>" + roleName + '</a>' + '</td>' +
                    '<td>' + procCreateSpans(labels, "LB") + '</td>' +
                    '<td>' + annotations + '</td>' +
                    '<td>' + creationTimestamp + '</td>' +
                    '</tr>');

                checkListCount++;
            }
        });

        if (G_ROLES_LIST_LENGTH < 1 || checkListCount < 1) {
            resultHeaderArea.hide();
            resultArea.hide();
            noResultArea.show();
        }
        else if(G_ROLES_LIST_GET_FIRST == true) {
            noResultArea.hide();
            resultHeaderArea.show();
            resultArea.html(htmlString);
            resultArea.show();

            resultTable.tablesorter({
                sortList: [[3, 1]] // 0 = ASC, 1 = DESC
            });

            resultTable.tablesorter();
            resultTable.trigger("update");
            $('.headerSortFalse > td').unbind();
        }

        else if(G_ROLES_LIST_GET_FIRST == false) {
            $('#rolesListArea tr:last').after(htmlString);
        }

        procSetToolTipForTableTd('resultRolesTable');
        procViewLoading('hide');

    };

</script>

<script>

    $(document).on("click", "#rolesMoreDetailBtn", function(){
        G_ROLES_LIST_GET_FIRST = false;
        getRolesList(<%= Constants.DEFAULT_LIMIT_COUNT %>,G_ROLES_LIST_CONTINUE_TOKEN);

    });

</script>