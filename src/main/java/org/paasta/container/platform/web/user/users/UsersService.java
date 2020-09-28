package org.paasta.container.platform.web.user.users;

import org.paasta.container.platform.web.user.common.RestTemplateService;
import org.paasta.container.platform.web.user.common.model.ResultStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;

import java.util.List;

import static org.paasta.container.platform.web.user.common.Constants.TARGET_CP_API;

/**
 * User Service 클래스
 *
 * @author hrjin
 * @version 1.0
 * @since 2020.09.22
 **/
@Service
public class UsersService {

    private final RestTemplateService restTemplateService;

    @Autowired
    public UsersService(RestTemplateService restTemplateService) {
        this.restTemplateService = restTemplateService;
    }

    public ResultStatus registerUser(Users users) {
        return restTemplateService.send(TARGET_CP_API, "/users", HttpMethod.POST, users, ResultStatus.class);
    }

    public UsersList getUsersList() {
        return restTemplateService.send(TARGET_CP_API, "/users", HttpMethod.GET, null, UsersList.class);
    }

    public List<String> getUsersNameList() {
        return restTemplateService.send(TARGET_CP_API, "/users", HttpMethod.GET, null, List.class);
    }
}
