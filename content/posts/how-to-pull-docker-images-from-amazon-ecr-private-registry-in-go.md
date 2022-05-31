---
title: "How to Pull Docker Images from Amazon ECR Private Registry in Go"
date: 2022-01-09T20:13:03+03:00
tags: ["go", "docker", "aws"]
showtoc: false
---

Pulling a docker image from [Amazon ECR](https://aws.amazon.com/ecr) private registry consists of several steps; configuration, authentication, and using the right commands. In this post, let's take a look at how to do that in Go.

## Prerequisites

#### Install [AWS SDK](https://aws.github.io/aws-sdk-go-v2/docs/getting-started) for Go

```shell
go get github.com/aws/aws-sdk-go-v2
go get github.com/aws/aws-sdk-go-v2/config
go get github.com/aws/aws-sdk-go-v2/credentials
go get github.com/aws/aws-sdk-go-v2/service/ecr
```

#### Install [Docker SDK](https://docs.docker.com/engine/api/sdk/#go-sdk) for Go

```shell
go get github.com/docker/docker/client
```

## Pulling Docker Image

### AWS in Go

First of all, we have to create a configuration for AWS. Let's wrap that in its own function. Follow [here](https://aws.github.io/aws-sdk-go-v2/docs/getting-started/#get-your-aws-access-keys) for getting AWS access keys. Also, please note that I use **`WithRegion`** and **`WithCredentialsProvider`** functions to customize the default AWS configuration. I do that just for the demonstration, so feel free to remove those lines if you want to stick with the shared AWS configuration in your machine.

> 1. load the default aws config; ~/.aws/config
> 2. customize region; this line can be removed if customization is not needed
> 3. customize credentials; this line can be removed if customization is not needed

```go
func newAWSConfig(ctx context.Context) (*aws.Config, error) {
	// #1
	cfg, err := awsconfig.LoadDefaultConfig(
		ctx,
		awsconfig.WithRegion("<region>"), // #2
		awsconfig.WithCredentialsProvider( // #3
			credentials.NewStaticCredentialsProvider(
				"<access-key>",
				"<secret-access-key>",
				"")))
	if err != nil {
		return nil, fmt.Errorf("failed to load aws config: %w", err)
	}
	return &cfg, nil
}
```

AWS configuration is done, and now we are ready to interact with the AWS services. Since we are dealing with Amazon ECR, we will create an Amazon ECR client for obtaining the login password to pull docker images.

> 1. get token 
> 2. validate token data
> 3. dereference pointer value for readability
> 4. decode token since it's base64 encoded
> 5. decoded value is in form of "username:password", so split it by ":"
> 6. return the second entry of the split for the password

```go
func getLoginPassword(ctx context.Context, cli *ecr.Client) (string, error) {
	// #1
	tkn, err := cli.GetAuthorizationToken(ctx, nil)
	if err != nil {
		return "", fmt.Errorf("failed to retrieve ecr token: %w", err)
	}

	// #2
	if len(tkn.AuthorizationData) == 0 {
		return "", fmt.Errorf("ecr token is empty")
	}
	if len(tkn.AuthorizationData) > 1 {
		return "", fmt.Errorf("multiple ecr tokens: length: %d", len(tkn.AuthorizationData))
	}
	if tkn.AuthorizationData[0].AuthorizationToken == nil {
		return "", fmt.Errorf("ecr token is nil")
	}

	// #3
	str := *tkn.AuthorizationData[0].AuthorizationToken

	// #4
	dec, err := base64.URLEncoding.DecodeString(str)
	if err != nil {
		return "", fmt.Errorf("failed to decode ecr token: %w", err)
	}

	// #5
	sps := strings.Split(string(dec), ":")
	if len(sps) != 2 {
		return "", fmt.Errorf("unexpected ecr token format")
	}

	// #6
	return sps[1], nil
}
```

### Docker in Go

Let's start with creating a docker client.

```go
func newDockerClient() (*client.Client, error) {
	cli, err := client.NewClientWithOpts(client.FromEnv)
	if err != nil {
		return nil, fmt.Errorf("failed to create docker client: %w", err)
	}
	return cli, nil
}
```

With the docker client we have just created, now we are ready to pull docker images from Amazon ECR using the ECR password. But first, we need to create an authentication configuration for the docker.

```go
auth := types.AuthConfig{
    Username: "AWS",
	Password: password,
}
```

Finally, we are ready to pull docker images from Amazon ECR. Our image variable will be similar to this: **`<account-id>.dkr.ecr.<region>.amazonaws.com/<name>:<tag>`**

> 1. encode auth config to json
> 2. encode auth data to base64 string
> 3. pull the image
> 4. send logs to standard output

```go
func pullImage(ctx context.Context, cli *client.Client, img string, auth types.AuthConfig) error {
	// #1
	authData, err := json.Marshal(auth)
	if err != nil {
		return err
	}

	// #2
	auths := base64.URLEncoding.EncodeToString(authData)

	// #3
	out, err := cli.ImagePull(
		ctx,
		img,
		types.ImagePullOptions{
			RegistryAuth: auths,
		})
	if err != nil {
		return fmt.Errorf("failed to pull image: %w", err)
	}
	defer out.Close()

	// #4
	_, err = io.Copy(os.Stdout, out)
	if err != nil {
		return fmt.Errorf("failed to read image logs: %w", err)
	}

	return nil
}
```

## Conclusion

We managed to pull docker images from Amazon ECR. Before finishing up, we can do one more thing; cleaning up. That's relatively simple, all we have to do is just calling the remove method.

```go
func removeImage(ctx context.Context, cli *client.Client, img string) error {
	_, err := cli.ImageRemove(
		ctx,
		img,
		types.ImageRemoveOptions{})
	if err != nil {
		return fmt.Errorf("failed to remove image: %w", err)
	}
	return nil
}
```

<br/>

Source code can be found on [gist](https://gist.github.com/aemdemir/3617228b47bd362d8d5da02065d7692e).