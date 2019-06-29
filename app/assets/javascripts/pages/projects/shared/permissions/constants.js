import { __ } from '~/locale';

export const visibilityOptions = {
  PRIVATE: 0,
  INTERNAL: 10,
  PUBLIC: 20,
};

export const visibilityLevelDescriptions = {
  [visibilityOptions.PRIVATE]: __(
    '只有项目成员访问才允许访问该项目。必须明确给每一个用户授权访问。',
  ),
  [visibilityOptions.INTERNAL]: __('The project can be accessed by any user who is logged in.'),
  [visibilityOptions.PUBLIC]: __(
    '任何人都可以访问该项目，无论是否登录。',
  ),
};
