package org.paasta.container.platform.web.user.common;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;


/**
 * Common Controller 클래스
 *
 * @author kjhoon
 * @version 1.0
 * @since 2020.09.15
 */
@Api(value = "commonController v1")
@RestController
public class commonController {

    private static final String BASE_URL = "/common";
    private final CommonService commonService;


    /**
     * Instantiates a new User controller
     *
     * @param commonService the common service
     */
    @Autowired
    public commonController(CommonService commonService) {
        this.commonService = commonService;
    }



    /**
     * Resources create 페이지 이동(Move Resources create page)
     *
     * @param httpServletRequest the http servlet request
     * @param namespace          the namespace
     * @param resourceKind       the resourceKind
     * @return the common resources create page
     */
    @ApiOperation(value = "Resources create 페이지 이동(Move Resources create page)", nickname = "createResource")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "namespace", value = "네임스페이스 명", required = true, dataType = "String", paramType = "path"),
            @ApiImplicitParam(name = "resourceKind", value = "리소스 kind 명",  required = true, dataType = "String", paramType = "path")
    })
    @GetMapping(value = Constants.CP_BASE_URL + Constants.URI_API_COMMON_RESOURCE_CREATE_VIEW)
    public ModelAndView createResource(HttpServletRequest httpServletRequest,
                                       @PathVariable(value = "namespace") String namespace,
                                       @PathVariable(value = "resourceKind") String resourceKind) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("namespace", namespace);
        mv.addObject("resourceKind", resourceKind);
        return commonService.setPathVariables(httpServletRequest, BASE_URL + "/resourceCreate", mv);
    }


    /**
     * Resources update 페이지 이동(Move Resources update page)
     *
     * @param httpServletRequest the http servlet request
     * @param namespace          the namespace
     * @param resourceKind       the resourceKind
     * @param resourceName       the resourceName
     * @return the common resource update page
     */
    @ApiOperation(value = "Resources create 페이지 이동(Move Resources create page)", nickname = "createResource")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "namespace", value = "네임스페이스 명", required = true, dataType = "String", paramType = "path"),
            @ApiImplicitParam(name = "resourceKind", value = "리소스 kind 명",  required = true, dataType = "String", paramType = "path"),
            @ApiImplicitParam(name = "resourceName", value = "리소스 명",  required = true, dataType = "String", paramType = "path")
    })
    @GetMapping(value = Constants.CP_BASE_URL + Constants.URI_API_COMMON_RESOURCE_UPDATE_VIEW)
    public ModelAndView updateResource(HttpServletRequest httpServletRequest,
                                       @PathVariable(value = "namespace") String namespace,
                                       @PathVariable(value = "resourceKind") String resourceKind,
                                       @PathVariable(value = "resourceName") String resourceName) {

        ModelAndView mv = new ModelAndView();
        mv.addObject("namespace", namespace);
        mv.addObject("resourceKind", resourceKind);
        mv.addObject("resourceName", resourceName);

        return commonService.setPathVariables(httpServletRequest, BASE_URL + "/resourceUpdate", mv);
    }

}