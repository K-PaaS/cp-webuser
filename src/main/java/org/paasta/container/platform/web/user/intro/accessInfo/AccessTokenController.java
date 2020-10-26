package org.paasta.container.platform.web.user.intro.accessInfo;

import org.paasta.container.platform.web.user.common.CommonService;
import org.paasta.container.platform.web.user.common.CommonUtils;
import org.paasta.container.platform.web.user.common.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

/**
 * AccessToken Controller 클래스
 *
 * @author hrjin
 * @version 1.0
 * @since 2020.10.14
 */
@Controller
public class AccessTokenController {

    @Value("${access.cp-user-id}")
    private String cpUserId;

    private static final String VIEW_URL = "/intro";
    private final CommonService commonService;
    private final AccessTokenService accessTokenService;


    /**
     * Instantiates a new Access Token controller
     *
     * @param commonService
     * @param accessTokenService
     */
    @Autowired
    public AccessTokenController(CommonService commonService, AccessTokenService accessTokenService) {
        this.commonService = commonService;
        this.accessTokenService = accessTokenService;
    }



    /**
     * Intro access info 페이지로 이동한다.
     *
     * @param httpServletRequest the http servlet request
     * @return the view
     */
    @GetMapping(value = Constants.URI_INTRO_ACCESS_INFO)
    public ModelAndView getIntroAccessInfo(HttpServletRequest httpServletRequest) {
        String userId = CommonUtils.getCookie(httpServletRequest, cpUserId);
        ModelAndView mv = new ModelAndView();
        mv.addObject("userId", userId);
        return commonService.setPathVariables(httpServletRequest, VIEW_URL + "/accessInfo", mv);
    }


    /**
     * Secret을 조회한다.
     *
     * @param namespace       the namespace
     * @param accessTokenName the access token name
     * @return the AccessToken
     */
    @GetMapping(value = Constants.API_URL + Constants.URI_API_SECRETS_DETAIL)
    @ResponseBody
    public AccessToken getSecret(@PathVariable(value = "namespace") String namespace, @PathVariable(value = "accessTokenName") String accessTokenName) {
        return accessTokenService.getToken(namespace, accessTokenName);
    }

}