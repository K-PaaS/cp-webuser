<%--
  Intro accessInfo

  @author hrjin
  @version 1.0
  @since 2020.09.29
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<div class="content">
    <jsp:include page="../common/contentsTab.jsp"/>
    <div class="cluster_tabs clearfix"></div>
    <div class="cluster_content01 row two_line two_view">
        <div class="sortable_wrap custom-sortable_wrap">
            <div class="sortable_top">
                <p>User Info</p>
            </div>
        </div>
        <div class="account_table access">
            <table>
                <colgroup>
                    <col style="width:100%;">
                </colgroup>
                <tbody>
                <tr>
                    <td>
                        <label for="access-user-name">User name *</label>
                        <input id="access-user-name" type="text" placeholder="User name" disabled>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="access-user-role">Role</label>
                        <input id="access-user-role" type="text" disabled>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="cluster_tabs clearfix"></div>
    <%--How to access :: BEGIN--%>
    <div class="cluster_content01 row two_line two_view paB40">
        <div class="sortable_wrap custom-sortable_wrap">
            <div class="sortable_top">
                <p>How to access</p>
            </div>
        </div>
        <div class="custom-access-wrap pd0">
            <div class="custom-access-title-wrap">
                <div class="custom-access-title">
                    <p>1.
                        <a href='javascript:void(0);' onclick="window.open('https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl')"><spring:message code="M0060" text="Kubectl 다운로드 및 설치"/></a>
                    </p>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title-wrap">
                <div class="custom-access-title">
                    <p>2. <spring:message code="M0061" text="환경 변수 설정"/></p>
                </div>
            </div>
            <div class="custom-access-contents-wrap">
                <div>
                    <p>※ For Linux</p>
                </div>
                <div class="custom-access-contents">
                    <div id="cpEnvironmentsForLinux">
                        <p>export CP_SERVICE_CLUSTER_NAME="<span class="cpClusterName"></span>"</p>
                        <p>export CP_SERVICE_CLUSTER_SERVER="<span class="cpClusterServer"></span>"</p>
                        <p>export CP_SERVICE_USER_NAME="<span class="cpUserName"></span>"</p>
                        <p>export CP_SERVICE_CONTEXT_NAME="<span class="cpContextName"></span>"</p>
                        <p>export CP_SERVICE_NAMESPACE_NAME="<span class="cpNamespace"></span>"</p>
                        <p class="custom-access-contents-overflow">export CP_SERVICE_CREDENTIALS_TOKEN="<span class="cpCredentialsToken"></span>"</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpEnvironmentsForLinux"></i>
                    </div>
                </div>
                <div class="maT10">
                    <p>※ For Windows</p>
                </div>
                <div class="custom-access-contents">
                    <div id="cpEnvironmentsForWindows">
                        <p>set CP_SERVICE_CLUSTER_NAME="<span class="cpClusterName"></span>"</p>
                        <p>set CP_SERVICE_CLUSTER_SERVER="<span class="cpClusterServer"></span>"</p>
                        <p>set CP_SERVICE_USER_NAME="<span class="cpUserName"></span>"</p>
                        <p>set CP_SERVICE_CONTEXT_NAME="<span class="cpContextName"></span>"</p>
                        <p>set CP_SERVICE_NAMESPACE_NAME="<span class="cpNamespace"></span>"</p>
                        <p class="custom-access-contents-overflow">set CP_SERVICE_CREDENTIALS_TOKEN="<span class="cpCredentialsToken"></span>"</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpEnvironmentsForWindows"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title-wrap">
                <div class="custom-access-title fa-pull-left">
                    <p>3. <spring:message code="M0062" text="Cluster 등록"/></p>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="custom-access-contents-wrap">
                <div>
                    <p>※ For Linux</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpClusterForLinux">
                        <p>kubectl config set-cluster \${CP_SERVICE_CLUSTER_NAME} --server=\${CP_SERVICE_CLUSTER_SERVER} --insecure-skip-tls-verify</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpClusterForLinux"></i>
                    </div>
                </div>
                <div class="maT10">
                    <p>※ For Windows</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpClusterForWindows">
                        <p>kubectl config set-cluster %CP_SERVICE_CLUSTER_NAME% --server=%CP_SERVICE_CLUSTER_SERVER% --insecure-skip-tls-verify</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpClusterForWindows"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title-wrap">
                <div class="custom-access-title">
                    <p>4. <spring:message code="M0063" text="Credential 등록"/></p>
                </div>
            </div>
            <div class="custom-access-title-caution">
                <p style="color: red;"><i class="fas fa-info-circle"></i>&nbsp;&nbsp;<spring:message code="M0064" text="토큰을 응용 프로그램과 공유 할 때 주의 하십시오. 공용 코드 저장소에 사용자 토큰을 게시하지 마십시오."/></p>
            </div>
            <div class="custom-access-contents-wrap">
                <div class="maT10">
                    <p>※ For Linux</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpCredentialForLinux">
                        <p>kubectl config set-credentials \${CP_SERVICE_USER_NAME} --token=\${CP_SERVICE_CREDENTIALS_TOKEN}</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpCredentialForLinux"></i>
                    </div>
                </div>
                <div class="maT10">
                    <p>※ For Windows</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpCredentialForWindows">
                        <p>kubectl config set-credentials %CP_SERVICE_USER_NAME% --token=%CP_SERVICE_CREDENTIALS_TOKEN%</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpCredentialForWindows"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title">
                <p>5. <spring:message code="M0065" text="Context 설정"/></p>
            </div>
            <div class="custom-access-contents-wrap">
                <div>
                    <p>※ For Linux</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpContextForLinux">
                        <p>kubectl config set-context \${CP_SERVICE_CONTEXT_NAME} --user=\${CP_SERVICE_USER_NAME} --namespace=\${CP_SERVICE_NAMESPACE_NAME} --cluster=\${CP_SERVICE_CLUSTER_NAME}</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpContextForLinux"></i>
                    </div>
                </div>
                <div class="maT10">
                    <p>※ For Windows</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpContextForWindows">
                        <p>kubectl config set-context %CP_SERVICE_CONTEXT_NAME% --user=%CP_SERVICE_USER_NAME% --namespace=%CP_SERVICE_NAMESPACE_NAME% --cluster=%CP_SERVICE_CLUSTER_NAME%</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpContextForWindows"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title">
                <p>6. <spring:message code="M0066" text="Context 사용 설정"/></p>
            </div>
            <div class="custom-access-contents-wrap">
                <div>
                    <p>※ For Linux</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpContextUseForLinux">
                        <p>kubectl config use-context \${CP_SERVICE_CONTEXT_NAME}</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpContextUseForLinux"></i>
                    </div>
                </div>
                <div class="maT10">
                    <p>※ For Windows</p>
                </div>
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpContextUseForWindows">
                        <p>kubectl config use-context %CP_SERVICE_CONTEXT_NAME%</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpContextUseForWindows"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap">
            <div class="custom-access-title">
                <p>7. <spring:message code="M0067" text="Config 구성 확인"/></p>
            </div>
            <div class="custom-access-contents-wrap">
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpConfigCheck">
                        <p>kubectl config view</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpConfigCheck"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="custom-access-wrap custom-paB40">
            <div class="custom-access-title">
                <p>8. <spring:message code="M0068" text="Resource 확인"/></p>
            </div>
            <div class="custom-access-contents-wrap">
                <div class="custom-access-contents">
                    <div class="fa-pull-left" id="cpResourceCheck">
                        <p>kubectl get all</p>
                    </div>
                    <div class="fa-pull-right">
                        <i class="fas fa-copy custom-access-copy-button" about="cpResourceCheck"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--How to access :: END--%>
</div>
<input type="hidden" id="useId" value="${userId}" />
<script type="text/javascript">
    var G_ROLE_NAME;
    var G_CA_CERT_TOKEN;
    var G_USER_ACCESS_TOKEN_NAME;
    var G_USER_ACCESS_TOKEN;

    // kubectl access guide variable
    var G_GUIDE_CLUSTER_NAME;
    var G_GUIDE_CLUSTER_SERVER;
    var G_GUIDE_USER_NAME;
    var G_GUIDE_CONTEXT_NAME;
    var G_GUIDE_NAMESPACE;


    // certification token download
    var downloadCrtToken = function () {
        var fileNameToSaveAs = "cluster-certificate.crt";
        var textToWrite = G_CA_CERT_TOKEN;

        var ie = navigator.userAgent.match(/MSIE\s([\d.]+)/),
            ie11 = navigator.userAgent.match(/Trident\/7.0/) && navigator.userAgent.match(/rv:11/),
            ieEDGE = navigator.userAgent.match(/Edge/g),
            ieVer=(ie ? ie[1] : (ie11 ? 11 : (ieEDGE ? 12 : -1)));

        if (ie && ieVer<10) {
            console.log("No blobs on IE ver<10");
            return;
        }

        var textFileAsBlob = new Blob([textToWrite], {
            type: 'text/plain'
        });

        if (ieVer>-1) {
            window.navigator.msSaveBlob(textFileAsBlob, fileNameToSaveAs);

        } else {
            var downloadLink = document.createElement("a");
            downloadLink.download = fileNameToSaveAs;
            downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
            downloadLink.onclick = function(e) { document.body.removeChild(e.target); };
            downloadLink.style.display = "none";
            document.body.appendChild(downloadLink);
            downloadLink.click();
        }
    };


    // GET User
    var getUser = function() {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_USERS_DETAIL %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE);

        var userId =  $("#useId").val();

        if (userId != null) {
            reqUrl += "?userId=" + userId;
        };

        procCallAjax(reqUrl, "GET", null, null, callbackGetUser);
    };

    // CALLBACK
    var callbackGetUser = function(data) {

        var f_srch_user = '사용자 상세 조회에 실패하였습니다.';

        var s_msg_f_srch_user= '<spring:message code="M0069" arguments='arg_f_srch_user' javaScriptEscape="true" text="사용자 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_user_lang = s_msg_f_srch_user.replace('arg_f_srch_user', f_srch_user);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_user_lang, false);
            return false;
        }

        G_GUIDE_CLUSTER_NAME = data.clusterName;
        G_GUIDE_CLUSTER_SERVER = data.clusterApiUrl;
        G_GUIDE_USER_NAME = data.userId;
        G_GUIDE_CONTEXT_NAME = G_GUIDE_USER_NAME + "-context";
        G_GUIDE_NAMESPACE = NAME_SPACE;
        G_ROLE_NAME = data.roleSetCode;
        G_USER_ACCESS_TOKEN_NAME = data.saSecret;

        $("#access-user-name").val(G_GUIDE_USER_NAME);
        $("#access-user-role").val(G_ROLE_NAME);

        procViewLoading('hide');
        getAccessToken();
    };


    // user 의 token 값 가져오기 (Get token value of user)
    var getAccessToken = function () {
        procViewLoading('show');
        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_SECRETS_DETAIL %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE)
            .replace("{accessTokenName:.+}", G_USER_ACCESS_TOKEN_NAME);

        procCallAjax(reqUrl, "GET", null, null, callbackGetAccessToken);
    };

    var callbackGetAccessToken = function (data) {

        var f_srch_acc = 'Access 정보 조회에 실패하였습니다.';
        var s_msg_f_srch_acc= '<spring:message code="M0070" arguments='arg_f_srch_acc' javaScriptEscape="true" text="Access 정보 조회에 실패하였습니다."/>';
        s_msg_f_srch_acc_lang = s_msg_f_srch_acc.replace('arg_f_srch_acc', f_srch_acc);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_acc_lang, false);
            return false;
        }

        G_CA_CERT_TOKEN = data.caCertToken;
        G_USER_ACCESS_TOKEN = data.userAccessToken;

        // kubectl access guide input logic
        $('.cpClusterName').html(G_GUIDE_CLUSTER_NAME);
        $('.cpClusterServer').html(G_GUIDE_CLUSTER_SERVER);
        $('.cpUserName').html(G_GUIDE_USER_NAME);
        $('.cpContextName').html(G_GUIDE_CONTEXT_NAME);
        $('.cpNamespace').html(G_GUIDE_NAMESPACE);
        $('.cpCredentialsToken').html(G_USER_ACCESS_TOKEN);

        procViewLoading('hide');
    };


    // BIND
    $(".custom-access-copy-button").on("click", function () {

        var cp_scr = '스크립트를 복사했습니다.';
        var f_cp_scr = '스크립트 복사에 실패했습니다.';
        var alert ='알림';
        var cfm = '확인';

        var s_msg_cp_scr = '<spring:message code="M0071" arguments='arg_cp_scr' javaScriptEscape="true" text="스크립트를 복사했습니다."/>';
        var s_msg_f_cp_scr = '<spring:message code="M0072" arguments='arg_f_cp_scr' javaScriptEscape="true" text="스크립트 복사에 실패했습니다."/>';
        var s_msg_alert = '<spring:message code="M0073" arguments='arg_alert' javaScriptEscape="true" text="알림"/>';
        var s_msg_cfm = '<spring:message code="M0022" arguments='arg_cfm' javaScriptEscape="true" text="확인"/>';

        s_msg_cp_scr_lang = s_msg_cp_scr.replace('arg_cp_scr', cp_scr);
        s_msg_f_cp_scr_lang = s_msg_f_cp_scr.replace('arg_f_cp_scr', f_cp_scr);
        s_msg_alert_lang = s_msg_alert.replace('arg_alert', alert);
        s_msg_cfm_lang = s_msg_cfm.replace('arg_cfm', cfm);

        var item = document.getElementById($(this).attr('about'));
        var reqValue = item.innerText || item.textContent;
        var resultString = (procSetExecuteCommandCopy(reqValue)) ? s_msg_cp_scr_lang : s_msg_f_cp_scr_lang;
        procSetLayerPopup(s_msg_alert_lang, resultString, s_msg_cfm_lang, null, 'x', null, null, null);
    });


    // ON LOAD
    $(document.body).ready(function () {
        getUser();

    });
</script>