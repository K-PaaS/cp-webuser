package org.paasta.container.platform.web.user.common.model;

import lombok.Data;

/**
 * Common Typed Local Object Reference Model 클래스
 *
 * @author jjy
 * @version 1.0
 * @since 2020.08.26
 */
@Data
public class CommonTypedLocalObjectReference {
    private String apiGroup;
    private String kind;
    private String name;
}
